Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYAIBjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYAIBjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYAIBjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:39:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYAIBjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:39:25 -0500
Date: Wed, 9 Jan 2008 02:41:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109014152.GJ2117@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <200801090140.58864.arnd@arndb.de> <20080109004748.GI2117@one.firstfloor.org> <200801090219.46876.arnd@arndb.de> <478423EC.5020000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478423EC.5020000@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 09:31:24PM -0400, Kevin Winchester wrote:
> Arnd Bergmann wrote:
> > On Wednesday 09 January 2008, Andi Kleen wrote:
> >> I imagined it would check for 
> >>
> >> +struct file_operations ... = { 
> >> +      ...
> >> +       .ioctl = ...
> >>
> >> That wouldn't catch the case of someone adding only .ioctl to an 
> >> already existing file_operations which is not visible in the patch context, 
> >> but that should be hopefully rare. The more common case is adding
> >> completely new operations
> > 
> > Right, this would work fine. We can probably even have a list of
> > data structures that work like file_operations in this regard.
> > 
> 
> file_operations & block_device_operations are the only two that I can find.

There are a few like scsi_host_template that don't have a unlocked_ioctl yet,
but that is just something that needs to be fixed.

-Andi
