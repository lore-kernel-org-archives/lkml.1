Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbXJEP3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbXJEP3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbXJEP2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:28:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:46874 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbXJEP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XtfyqttQpP0Qdth1m1OUJunzeXt+7YKqoHn0z/cBfLCr9M5xDXpR2MzbFplgznh8+c8lXE3j03ZV/zNUGYdeU9JfBf2Nc329nxVAx9j338QozP4Rc3HLga9OzzIJhi+g1orJQV1BcXQDSTwGW7FFE4En9Gyn7fLIEnuUQ2Wz6Uk=
Message-ID: <2c0942db0710050828jcb161c0qc10e65f7f65af6c4@mail.gmail.com>
Date: Fri, 5 Oct 2007 08:28:50 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Luciano Rocha" <strange@nsk.no-ip.org>, linux-kernel@vger.kernel.org
Subject: Re: can't change euid 0 to uid != running user
In-Reply-To: <20071005142541.GA9224@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071005142541.GA9224@bit.office.eurotux.com>
X-Google-Sender-Auth: 3393cafdb4683451
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Luciano Rocha <strange@nsk.no-ip.org> wrote:
> I have the following problem:
> $ sudo -u ie -s # or sudo su ie
> unable to change to runas uid: Resource temporarily unavailable
>
> Works:
> $ sudo su, followed by su ie
>
> The first sudo also worked while I had a shell under user ie.
>
> When I exited, it stopped working, but it is now working every time I
> trie it.
>
> dmesg shows:
>
> [82602.729330] kobject_add failed for 504 with -EEXIST, don't try to
>                register things with the same name in the same directory.
> [82602.729365]  [<c04b9195>] kobject_shadow_add+0x16e/0x1a0
> [82602.729383]  [<c04b9480>] kobject_set_name+0x29/0x92
> [82602.729504]  [<c04238ea>] user_kobject_create+0x6a/0x90
> [82602.729520]  [<c0423cce>] alloc_uid+0x18f/0x1d7
> [82602.729530]  [<c0427030>] set_user+0x1c/0x8f
> [82602.729539]  [<c0428b5f>] sys_setresuid+0xd5/0x162
> [82602.729552]  [<c0403e6a>] syscall_call+0x7/0xb
> [82602.729575]  =======================
>
> $ git describe
> v2.6.23-rc9-156-ga95dacb
>
> (Clone of Linus' tree, after rc9, with some patches from
> mingo/linux-2.6-sched-devel.git, and a fix for lguest (didn't link due
> to kasprintf)).

Hmm, it works for me under 2.6.23-rc6, so it's either a difference
between our .configs or a late regression. If you could bisect the
problem (starting with reverting Ingo's sched devel patches and lguest
patches, and trying that), then that would tell us where the issue is.

Ray
