Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbYJDTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbYJDTFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYJDTFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:05:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:1770 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYJDTFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AecYu/wtCS3stb26rV91J8BUYivW9ztSguKrfYatdJXpG8quqkx4CaCNwi/lidBnqF
         xb4+hBl5RQOprUX7xmBSgK8WnuFgsdvMEf22BFtOk2eI3WwoS0yvc8EPTnmwMt/Vd1Ep
         n2jIKDz7gVx4Ai1BZ5Sm2DGi7KDCWwRmL9l38=
Message-ID: <c62985530810041205p2ccf6de4l5ad4d461b29b727b@mail.gmail.com>
Date: Sat, 4 Oct 2008 21:05:05 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH -tip] Tracing/fastboot: Only trace non-module initcalls
Cc: "Alan Jenkins" <aj504@student.cs.york.ac.uk>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <48E67773.50402@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E62089.7050006@gmail.com> <48E659CB.5030902@tuffmail.co.uk>
	 <c62985530810031059v5ed44e04qebaf9453710e76c1@mail.gmail.com>
	 <48E67773.50402@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/3 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> If you want to disable non-module initcalls, then what do you have left
> that you want to trace after "Freeing unused kernel memory"?
>
> On my desktop dmesg I can see that the initramfs is loaded and started
> some time before the initcalls finish.  The initramfs includes udev
> which loads many modules; I see network, usb, sata being initialised
> before the "Freeing unused kernel memory" message.  Um...  your changes
> will _not_ stop the initcalls from these modules being shown.
>
> So I think your patch description is a bit inaccurate, and I don't
> understand what you are trying to achieve.

Hmm I'm beginning to understand what you say. Actually I didn't think
about initramfs that could launch
modules initcalls early.
It seems that modules initcalls are launched with the builtin
initcalls when one use initramfs.
Since I'm not using it, I see only the builtin initcalls before the
message of memory freeing.

I missed that point. And actually I misunderstood the real problem. My
issues with the graph happened
because of a bug in the bootgraph.pl script.
I have a patch ready that corrects it. I'm going to post it and
explain the real problem.

Thanks Alan!
