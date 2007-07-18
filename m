Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXGRQU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXGRQU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933221AbXGRQUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:20:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:21378 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933248AbXGRQUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OOpipTOUh70JVSPOfv4bLSeybRRckms/GnaP2kBxinELQFY/y72ShhHzUFUKn0e7h2lvAS1smYASS2x1UXudtqqy+iW61uycUouB15LhtQrghEhv5GRui/z/uwyTNhuhmikXKfXryAVJsnH+1odjJqF5xIxpEmXiEuHXB4hG45s=
Message-ID: <469E3DD8.80607@gmail.com>
Date: Thu, 19 Jul 2007 01:20:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure
 path
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>	 <20070718071445.GI23568@htj.dyndns.org>	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>	 <469E2A68.6010307@gmail.com>	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com> <a781481a0707180830g44cdd38etb4a540afce218065@mail.gmail.com>
In-Reply-To: <a781481a0707180830g44cdd38etb4a540afce218065@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>> On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
>> > Satyam Sharma wrote:
>> > > On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
>> > >> There is a subtle bug in sysfs_create_link() failure path.  When
>> > >> symlink creation fails because there's already a node with the same
>> > >> name, the target sysfs_dirent is put twice - once by failure path of
>> > >> sysfs_create_link() and once more when the symlink is released.
>> > >
>> > > The "symlink" is released? But the creation of the symlink is
>> > > precisely what failed here ... did it not?
>> > >
>> > >> Fix it by making only the symlink node responsible for putting
>> > >> target_sd.
>> > >
>> > > And again ... the changelog sounds confusing indeed, perhaps I'm
>> > > not familiar enough with sysfs symlink-related terminology/semantics.
>> > > Care to elaborate?
> 
> BTW, please do explain this one to me, if you can find the time :-)

A symlink node holds two sd's.  Its parent as all other sd nodes and the
sd the symlink point to.  When the symlink is released (its refcnt goes
to zero), it puts both.  In this bug, the symlink is released twice -
once in the error handling path and one more time when symlink is released.

-- 
tejun
