Return-Path: <linux-kernel-owner+w=401wt.eu-S964941AbXHYL5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941AbXHYL5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 07:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbXHYL5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 07:57:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1603 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750765AbXHYL5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 07:57:14 -0400
Date: Sat, 25 Aug 2007 11:08:26 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Kentaro Takeda <k.takeda26@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 14/15] Conditional permission support.
Message-ID: <20070825110825.GB5850@ucw.cz>
References: <46CED214.6050505@gmail.com> <46CED5C6.8050501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CED5C6.8050501@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch allows administrators use conditional permission.
> TOMOYO Linux supports conditional permission based on
> process's UID,GID etc. and/or requested pathname's UID/GID.
> 
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

> + * Since the trailing spaces are removed by tmy_normalize_line(),
> + * the last "\040if\040" sequence corresponds to condition part.
> + */
> +char *tmy_find_condition_part(char *data)
> +{
> +	char *cp = strstr(data, " if ");
> +	if (cp) {
> +		char *cp2;
> +		while ((cp2 = strstr(cp + 3, " if ")) != NULL)
> +			cp = cp2;
> +		*cp++ = '\0';
> +	}
> +	return cp;
> +}
...

> +	unsigned long left_min = 0;
> +	unsigned long left_max = 0;
> +	unsigned long right_min = 0;
> +	unsigned long right_max = 0;
> +	if (strncmp(condition, "if ", 3))
> +		return NULL;
> +	condition += 3;
> +	start = condition;
> +	while (*condition) {
> +		if (*condition == ' ')
> +			condition++;
> +		for (left = 0; left < MAX_KEYWORD; left++) {
> +			if (strncmp(condition, cc_keyword[left].keyword,
> +				    cc_keyword[left].keyword_len))
> +				continue;
> +			condition += cc_keyword[left].keyword_len;
> +			break;
> +		}
> +		if (left == MAX_KEYWORD) {
> +			if (!tmy_parse_ulong(&left_min, &condition))
> +				goto out;
> +			counter++; /* body */
> +			if (*condition != '-')
> +				goto not_range1;
> +			condition++;
> +			if (!tmy_parse_ulong(&left_max, &condition)
> +			    || left_min > left_max)
> +				goto out;
> +			counter++; /* body */
> +not_range1: ;
> +		}
> +		if (strncmp(condition, "!=", 2) == 0)
> +			condition += 2;
> +		else if (*condition == '=')
> +			condition++;
> +		else
> +			goto out;
> +		counter++; /* header */
> +		for (right = 0; right < MAX_KEYWORD; right++) {
> +			if (strncmp(condition, cc_keyword[right].keyword,
> +				    cc_keyword[right].keyword_len))
> +				continue;
> +			condition += cc_keyword[right].keyword_len;
> +			break;
> +		}

What is that? Language parser in kernel?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
