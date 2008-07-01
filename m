Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYGASQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYGASQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYGASQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:16:14 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:7047 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYGASQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=fckIvkFVHGUYZK07zwttTAB7pHFaPKtF4guNMGUJyCFNaCdWb/cn3PvQeEjRHMKBlM
         n2n+pyMYSqEalBAxGgYtmiEueFdJeWUAhjCuESjmn771yfzKfoHU2K8PsPeU2c8XJ7oa
         oz3g6zjLMIUoMVBPMO0hudgAL/yNNDM9Oflmk=
Message-ID: <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>
Date: Tue, 1 Jul 2008 20:16:11 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Philippe De Muyter" <phdm@macqel.be>
Subject: Re: mmap'ed memory in core files ?
Cc: linux-kernel@vger.kernel.org, libdc1394-devel@lists.sourceforge.net,
       "Michael Kerrisk" <mtk.manpages@gmail.com>
In-Reply-To: <20080701132149.GA32510@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701132149.GA32510@frolo.macqel>
X-Google-Sender-Auth: b64305a1dd9398dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/08, Philippe De Muyter <phdm@macqel.be> wrote:
> Hello everybody,
>
>  I develop video acquisition software using the video1394 interface.
>  The images grabbed by the camera and iee1394 bus are kept in kernel
>  memory and made available to the user program through a mmap call done
>  in the libdc1394 library :
>
>  dma_ring_buffer= mmap(0, vmmap.nb_buffers * vmmap.buf_size,
>                 PROT_READ|PROT_WRITE,MAP_SHARED, craw->capture.dma_fd, 0);
>
>  Sometimes, my program crashes and produces a core file :)  It seems to
>  me that the core file does not contain the mmap'ed memory and hence
>  I cannot replay my program with the same image for debugging purpose.
>
>  Is it possible to configure the kernel through /proc, or through the mmap
>  system call to have that mmapped segment in the core file, or do I need
>  to modify the kernel itself to obtain the behaviour I want ?  If I
>  need to modify the kernel, can some kind soul provide me some pointers ?


Have a look at the section "Controlling which mappings are written to
the core dump" in a recent core.5 man page:
http://www.kernel.org/doc/man-pages/online/pages/man5/core.5.html

Cheers,

Michael
