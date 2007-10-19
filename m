Return-Path: <linux-kernel-owner+w=401wt.eu-S935213AbXJSFhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935213AbXJSFhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933650AbXJSFhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:37:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41883 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbXJSFhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:37:09 -0400
Date: Fri, 19 Oct 2007 06:37:04 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Newall <david@davidnewall.com>
Cc: jaroslav.sykora@gmail.com, Jan Engelhardt <jengelh@computergmbh.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
Message-ID: <20071019053704.GR8181@ftp.linux.org.uk>
References: <200710181721.09201.jara@sin.cvut.cz> <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr> <200710181907.58643.jara@sin.cvut.cz> <4717BBBB.6040205@davidnewall.com> <4717C419.8060602@davidnewall.com> <20071018204703.GQ8181@ftp.linux.org.uk> <47181D0C.3040504@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47181D0C.3040504@davidnewall.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 12:27:16PM +0930, David Newall wrote:

> >Learn to read.  Linux has never allowed that.  Most of the Unix systems
> >do not allow that.
> 
> I did read the claim and it is ambiguous, in that it can reasonably be 
> read to mean that most UNIX systems never allowed such links, which is 
> wrong.  All UNIX systems allowed it until relatively recently.

FVO"relatively recently" exceeding a decade and half.  In any case,
it's _trivial_ to get fs corruption on any system with such links -
play with rename() races a bit and you'll get it.  And yes, it does
include 4.4BSD and quite a chunk of even later history.

Anyway, you are quite welcome to propose a sane locking scheme capable
of dealing with that mess.

As for the posted patch, AFAICS it's FUBAR in handling of .. in such
directories.  Moreover, how are you going to keep that shadow tree
in sync with the main one if somebody starts doing renames in the
latter?  Or mount --move, or...
