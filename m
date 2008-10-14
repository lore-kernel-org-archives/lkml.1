Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYJNJPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYJNJPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYJNJO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:14:58 -0400
Received: from 1-1-4-20a.ras.sth.bostream.se ([82.182.72.90]:57059 "EHLO
	amd.kenjo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479AbYJNJO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:14:57 -0400
Subject: Re: weird throughput on write to SATA disk
From: kenneth johansson <ken@kenjo.org>
To: Grant Grundler <grundler@google.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <da824cf30810131833g6e509d0dvb6cce6c7220a1a28@mail.gmail.com>
References: <1223925629.3947.7.camel@duo>
	 <da824cf30810131407m1a73bd11xa30fd118ee5a4c8f@mail.gmail.com>
	 <1223932956.3947.22.camel@duo>
	 <da824cf30810131434r34179666kc8d075c7eecdbbae@mail.gmail.com>
	 <1223936351.3947.41.camel@duo>
	 <da824cf30810131833g6e509d0dvb6cce6c7220a1a28@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 11:14:54 +0200
Message-Id: <1223975694.3947.77.camel@duo>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 18:33 -0700, Grant Grundler wrote:
> On Mon, Oct 13, 2008 at 3:19 PM, kenneth johansson <ken@kenjo.org> wrote:
> ...
> >> Can you try "dd oflag=direct if=/dev/null of=/dev/sdb bs=64k"?
> >
> > I changed to use O_DIRECT and it's much more consistent now. 69-75 with
> > 74 about 95% of the time.
> 
> That's low but it could be worse. Many things can contribute to slow
> disks. 
Well my main problem was that it was fluctuating so much that can't be
right. 

> Favorites are overtemp (See SMART field 194) and vibration (no
> measurement possible w/o special equipment). "dd" isn't exactly a
> performance application until one uses really big block sizes (1MB or
> larger).
All my numbers comes from using 1MB blocks. but I'm not using dd.
After removing the logic that actually put some data into the buffers I
do get about 105 MB/sec using O_DIRECT. I'm doing a full disk write now
to get a reference plot. Not using O_DIRECT should be almost identical. 


> > the disk is supposed to have 105 115 sustained
> > data rate.
> 
> Where did 105-115 number come from?
datasheet . they listed two drives in the same column so that was not
the range it was sustained OD and the model I have max out at 105. 


