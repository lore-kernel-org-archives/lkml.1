Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297Ab0ARBru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0ARBru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660Ab0ARBrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:47:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55719 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0ARBrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 20:47:49 -0500
Message-ID: <4B53BDC5.1010201@cn.fujitsu.com>
Date: Mon, 18 Jan 2010 09:47:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIEdvZGRhcmQgUm9zYQ==?= <andre.goddard@gmail.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Alex Riesen <raa.lkml@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] string: teach strnstr() to not search past NUL-terminator
References: <cover.1263675077.git.andre.goddard@gmail.com> <30e5fd087ee6fbe992cde8f09d945ed160b0c117.1263675077.git.andre.goddard@gmail.com>
In-Reply-To: <30e5fd087ee6fbe992cde8f09d945ed160b0c117.1263675077.git.andre.goddard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

André Goddard Rosa wrote:
> As noticed by Alex Riesen at:
> http://marc.info/?l=linux-kernel&m=126364040821071&w=2
> 

Please don't make this change, it's the user's responsibility
to make sure @len won't exceed @s1's length.

All the string functions of "n" version should work when
@s1 is not null-terminated, so don't call strlen() on @s1.

> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
> cc: Li Zefan <lizf@cn.fujitsu.com>
> cc: Alex Riesen <raa.lkml@gmail.com>
> cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  lib/string.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/string.c b/lib/string.c
> index 0f86245..94bad34 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -689,11 +689,13 @@ EXPORT_SYMBOL(strstr);
>   */
>  char *strnstr(const char *s1, const char *s2, size_t len)
>  {
> -	size_t l1 = len, l2;
> +	size_t l1, l2;
>  
>  	l2 = strlen(s2);
>  	if (!l2)
>  		return (char *)s1;
> +	l1 = strlen(s1);
> +	l1 = (l1 <= len) ? l1 : len;
>  	while (l1 >= l2) {
>  		l1--;
>  		if (!memcmp(s1, s2, l2))
