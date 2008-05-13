Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbYEMVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbYEMVRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759230AbYEMVRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:17:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:41970 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671AbYEMVRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sNki9zqGrlCLB8Nt6eNLXZNQzI+lukn5BW2jVkhux7Vpjd9gKA94utFX+aRw4emhE4hQ2dtkc16rx/bxAYyuOKeeNiHFwLRyEFpfHDshLlArln88Yzrdl+KNDrGsD8Y28sUm9VAscogQL6h95LPebZtJoZ4Q8Dc/fIrkRWM9pk4=
Date: Wed, 14 May 2008 02:12:27 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
Message-ID: <20080513221227.GA7164@martell.zuzino.mipt.ru>
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com> <20080422192928.GA15768@martell.zuzino.mipt.ru> <480E8507.8050801@ak.jp.nec.com> <20080423070328.GA5006@martell.zuzino.mipt.ru> <480EE755.4090202@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480EE755.4090202@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> You claim that libcap people can't or don't want to parse such file?
>
> Yes,
> In the previous discussion, it was undesirable idea to parse a file
> to obtain a new/unknown capability name/code pair, because it tends
> to have bigger number and appears at the tail.
> (If my brain memories it correctly.)
>
>> 0	CAP_CHOWN
>> 1	CAP_DAC_OVERRIDE
>> 2	CAP_DAC_READ_SEARCH
>> 3	CAP_FOWNER
>> 4	CAP_FSETID
>> 5	CAP_KILL
>> 6	CAP_SETGID
>> 7	CAP_SETUID
>> 8	CAP_SETPCAP
>> 9	CAP_LINUX_IMMUTABLE
>> 10	CAP_NET_BIND_SERVICE
>> 11	CAP_NET_BROADCAST
>> 12	CAP_NET_ADMIN
>> 13	CAP_NET_RAW
>> 14	CAP_IPC_LOCK
>> 15	CAP_IPC_OWNER
>> 16	CAP_SYS_MODULE
>> 17	CAP_SYS_RAWIO
>> 18	CAP_SYS_CHROOT
>> 19	CAP_SYS_PTRACE
>> 20	CAP_SYS_PACCT
>> 21	CAP_SYS_ADMIN
>> 22	CAP_SYS_BOOT
>> 23	CAP_SYS_NICE
>> 24	CAP_SYS_RESOURCE
>> 25	CAP_SYS_TIME
>> 26	CAP_SYS_TTY_CONFIG
>> 27	CAP_MKNOD
>> 28	CAP_LEASE
>> 29	CAP_AUDIT_WRITE
>> 30	CAP_AUDIT_CONTROL
>> 31	CAP_SETFCAP
>> 32	CAP_MAC_OVERRIDE
>> 33	CAP_MAC_ADMIN
>> That's what you claim? Do I undestand you correctly?
>
> Yes, but I don't *oppose* your approach. :)
>
> BTW, I think "version" info should be included as follows:
>   0x20071026  vesion
>   0 cap_chown
>   1 cap_dac_override
>   :    :

It shouldn't. You can do capget(42, ...);, get EINVAL and current
version written back.

Wrap this in libcap if needed.

