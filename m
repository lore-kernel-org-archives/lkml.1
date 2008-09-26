Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYIZV0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYIZV0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYIZV0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:26:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYIZV0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:26:21 -0400
To: Chris Snook <csnook@redhat.com>
Cc: Martin Knoblauch <knobi@knobisoft.de>, linux-kernel@vger.kernel.org,
       Peter zijlstra <a.p.zijlstra@chello.nl>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, systemtap@sources.redhat.com
Subject: Re: How to find out, what "pdflush" is working on
References: <849662.25086.qm@web32602.mail.mud.yahoo.com>
	<48D003F1.50101@redhat.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 26 Sep 2008 17:24:41 -0400
In-Reply-To: <48D003F1.50101@redhat.com> (Chris Snook's message of "Tue, 16 Sep 2008 15:07:29 -0400")
Message-ID: <y0mk5cymwh2.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [...]
>> Is there a way to find out what a certain instance of "pdflush" is
>> working on? Like which block-device or which fliesystem it is
>> writing to? [...]

Something based upon the following systemtap script may help:

probe kernel.function("__writeback_single_inode") {
  if (execname() == "pdflush")
     printf("pdflush %d writeback bdev %x inode %x\n", tid(), $inode->i_rdev, $inode->i_ino) 
}

Other fields are available as $inode->FOO.

- FChE
