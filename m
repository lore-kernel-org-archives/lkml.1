Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZFCVH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZFCVH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZFCVHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:07:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34592 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791AbZFCVHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:07:19 -0400
Date: Wed, 3 Jun 2009 22:07:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
Message-ID: <20090603220739.1f6fb518@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0906031542180.20254@gentwo.org>
References: <20090530230022.GO6535@oblivion.subreption.com>
	<alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>
	<20090531022158.GA9033@oblivion.subreption.com>
	<alpine.DEB.1.10.0906021130410.23962@gentwo.org>
	<20090602203405.GC6701@oblivion.subreption.com>
	<alpine.DEB.1.10.0906031047390.15621@gentwo.org>
	<20090603182949.5328d411@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0906031032390.4880@localhost.localdomain>
	<20090603180037.GB18561@oblivion.subreption.com>
	<alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
	<20090603183939.GC18561@oblivion.subreption.com>
	<alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>
	<alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>
	<alpine.DEB.1.10.0906031458250.9269@gentwo.org>
	<20090603202117.39b070d5@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0906031542180.20254@gentwo.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You need it in the default (no security) version of security_file_mmap()
> > in security.h not hard coded into do_mmap_pgoff, and leave the one in
> > cap_* alone.
> 
> But that would still leave it up to the security "models" to check
> for basic security issues.

Correct. You have no knowledge of the policy at the higher level. In the
SELinux case security labels are used to identify code which is permitted
to map low pages. That means the root/RAW_IO security sledgehammer can be
replaced with a more secure labelling system.

Other policy systems might do it on namespaces (perhaps /bin
and /usr/bin mapping zero OK, /home not etc)

