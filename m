Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0BDH6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:58:48 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33421 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab0BDH6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:58:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wuh/YzdTM+h/9Vkh8WrAdGFMaOAt6jTSWwe+WT/JjXn58Cn16Cusc9aSE0LcRXMhp3
         AYXvqTlLtzEoVwsNJrKXQvTmLxE4QMKkPx35V7QaL7gsE641UuZq0b5rVCGx3gge0vm4
         Sfm/z0ctVP4gs1LWl9jJj+lqjP4vG0tfRKpf4=
MIME-Version: 1.0
In-Reply-To: <20100203233643.GI19355@outflux.net>
References: <20100202055354.GV19355@outflux.net>
	 <4B67C2EA.705@schaufler-ca.com> <20100202202054.GW19355@outflux.net>
	 <20100202212510.GG32305@us.ibm.com>
	 <alpine.LRH.2.00.1002030859220.14592@tundra.namei.org>
	 <20100203233643.GI19355@outflux.net>
Date: Thu, 4 Feb 2010 08:58:43 +0100
Message-ID: <81b0412b1002032358j163d2e3fm2c0353ba3ec2842a@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] syslog: distinguish between /proc/kmsg and 
	syscalls
From: Alex Riesen <raa.lkml@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Robin Getz <rgetz@analog.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Paul Moore <paul.moore@hp.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Etienne Basset <etienne.basset@numericable.fr>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       LKLM <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 00:36, Kees Cook <kees.cook@canonical.com> wrote:
> @@ -888,12 +889,16 @@ error:
>  /**
>  * cap_syslog - Determine whether syslog function is permitted
>  * @type: Function requested
> + * @from_file: Whether this request came from an open file (i.e. /proc)
>  *
>  * Determine whether the current process is permitted to use a particular
>  * syslog function, returning 0 if permission is granted, -ve if not.
>  */
> -int cap_syslog(int type)
> +int cap_syslog(int type, bool from_file)
>  {
> +       /* /proc/kmsg can open be opened by CAP_SYS_ADMIN */
> +       if (type != 1 && from_file)
> +               return 0;

"can open be opened"?
