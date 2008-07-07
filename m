Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYGGTOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYGGTOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYGGTNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:13:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYGGTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:13:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=RziuF0qWZu6uwW7DE0k9z19ecK/V9xX536qylw2g/oC/HKDnHn6bUV2Dz1EG4rbFo
	3hMFw76pGMimTmcOzdklQ==
Message-ID: <6599ad830807071213u7334cafanc6f2a0b7c4f53ba2@mail.gmail.com>
Date: Mon, 7 Jul 2008 12:13:43 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] devcgroup: always show unsigned major/minor num
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <486F0918.5090707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486F0918.5090707@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2008 at 10:39 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>  # echo "b $((0x7fffffff)):$((0x80000000)) rwm" > devices.allow
>  # cat devices.list
>  b 214748364:-21474836 rwm
>
> though a major/minor number of 0x800000000 is meaningless, we
> should not cast it to a negative value.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  security/device_cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index fd764a0..1e2e28a 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -222,7 +222,7 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
>  #define DEVCG_DENY 2
>  #define DEVCG_LIST 3
>
> -#define MAJMINLEN 10
> +#define MAJMINLEN 13
>  #define ACCLEN 4
>
>  static void set_access(char *acc, short access)
> @@ -254,7 +254,7 @@ static void set_majmin(char *str, unsigned m)
>        if (m == ~0)
>                sprintf(str, "*");

Can't this just be strcat(str, "*")?

>        else
> -               snprintf(str, MAJMINLEN, "%d", m);
> +               snprintf(str, MAJMINLEN, "%u", m);

I'm not sure that using snprintf() helps here over just sprintf() -
we're not actually basing it on the available space in the string,
we're just assuming there's enough space.

Paul
