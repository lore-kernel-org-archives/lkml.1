Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbYJMSiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbYJMSiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYJMSiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:38:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764AbYJMSiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:38:08 -0400
Message-ID: <48F395AA.30208@redhat.com>
Date: Mon, 13 Oct 2008 14:38:34 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Stefan Monnier <monnier@iro.umontreal.ca>, linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com> <20081012143505.GA15799@logfs.org> <48F385B5.1040503@redhat.com> <20081013181333.GB22447@logfs.org>
In-Reply-To: <20081013181333.GB22447@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Mon, 13 October 2008 13:30:29 -0400, Chris Snook wrote:
>>>> logfs tries to solve the write amplification problem by forcing all write 
>>>> activity to be sequential.  I'm not sure how mature it is.
>>> Still under development.  What exactly do you mean by the write
>>> amplification problem?
>> Write amplification is where a 512 byte write turns into a 128k write, 
>> due to erase block size.
> 
> Ah, yes.  Current logfs still triggers that a bit too often.  I'm
> currently working on the format changes to avoid the amplification as
> much as possible.
> 
> Another nasty side effect of this is that heuristics for wear leveling
> are always imprecise.  And wear leveling is still required for most
> devices.  See http://www.linuxconf.eu/2007/papers/Engel.pdf
> 
>> Intel is claiming a write amplification factor of 1.1.  Either they're 
>> using very small erase blocks, or doing something very smart in the 
>> controller.
> 
> With very small erase blocks the facter should be either 1 or 2, not
> 1.1.  Most likely they work very much like logfs does, essentially doing
> the whole log-structured thing internally.
> 
> Jörn
> 

As I understand it, they mean that in a real-world workload that writes 1x data, 
a total of 1.1x is written on flash.  Real-world writes are usually, but not 
always, larger than a single sector.  Of course, the validity of this number 
depends greatly on the test.

If someone has more info on the Intel devices, please clue me in.

-- Chris
