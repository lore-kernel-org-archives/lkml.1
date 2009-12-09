Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZLIBp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZLIBp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 20:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZLIBpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 20:45:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55404 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZLIBpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 20:45:54 -0500
Date: Wed, 9 Dec 2009 01:45:59 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, re.emese@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
Message-ID: <20091209014559.GP14381@ZenIV.linux.org.uk>
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com> <20091209013109.GA18448@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209013109.GA18448@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 01:31:10AM +0000, Ralf Baechle wrote:
> On Sun, Dec 06, 2009 at 08:14:46AM +0300, Alexey Dobriyan wrote:
> 
> > Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
> > Content-Type: text/plain; charset=ISO-8859-1
> > 
> > > -   	struct inode *(*alloc_inode)(struct super_block *sb);
> > > +   	struct inode *(* const alloc_inode)(struct super_block *sb);
> > 
> > Good rule is if adding const doesn't move object from one section
> > to another, it isn't worth it.
> 
> On MIPS I've changed a few pointer arguments that frequently were abused
> by platform-specific code to const just to make sure such code blows up
> at compile time and not later in my mail folder at review time.

Seriously, folks, that looks like a fun sparse project: new type attribute
that makes pointer conversions complain (inherited by aggregates containing
one of such things) + one that restricts storage classes (again, inherited
the same way).  Another fun attribute: "no embedding into other objects".
__force casts would suppress complaints in places where e.g. noconvert
objects get allocated.
