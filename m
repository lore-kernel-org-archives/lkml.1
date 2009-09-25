Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbZIYINv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbZIYINv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZIYINr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:13:47 -0400
Received: from centrinvest.ru ([94.25.115.130]:53612 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZIYINq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:13:46 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Fri, 25 Sep 2009 12:13:45 +0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 4/5 v2] tracing/filters: Provide basic regex support
Message-ID: <20090925081345.GA9236@centrinvest.ru>
Mail-Followup-To: Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
 <1253821775-8618-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253821775-8618-5-git-send-email-fweisbec@gmail.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 267, 09 24, 2009 at 09:49:34PM +0200, Frederic Weisbecker wrote:
> This patch provides basic support for regular expressions in filters.

> +/* Basic regex callbacks */
> +static int regex_match_full(char *str, struct regex *r, int len)
> +{
> +	if (strncmp(str, r->pattern, len) == 0)
> +		return 1;
> +	return 0;
> +}
> +
> +static int regex_match_front(char *str, struct regex *r, int len)
> +{
> +	if (strncmp(str, r->pattern, len) == 0)
> +		return 1;
> +	return 0;
> +}

These two functions are identical, what's the reason to keep them separate ?
And why not simply return strncmp(str, r->pattern, len) == 0 ?
