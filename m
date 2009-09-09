Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZIIRUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZIIRUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZIIRUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbZIIRUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:20:46 -0400
Date: Wed, 9 Sep 2009 13:20:39 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090909132039.1ca47cd4@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
	<20090905071052.50501826@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
	<20090909125352.1c7b57d2@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 13:07:52 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 9 Sep 2009, Jeff Layton wrote:
> 
> > My suspicion would be that the server needs to perform an oplock break
> > to another client before it can send the response. The only way I know
> > how to tell that is to sniff all SMB traffic on the server and watch
> > for oplock break calls to other clients when these stalls occur.
> 
> That could be tested by switching them off right? If I do
> 
> echo 0 >/proc/fs/cifs/OplockEnabled
> 
> and then remount the volume it should switch off oplocks?
> 
> This has no effect on the stalls.
> 

That'll stop your client from requesting oplocks, but that won't
prevent others from doing so. If my suspicion is correct, then another
client is holding an oplock and the server needs to break it before it
can reply to yours.

Unfortunately I doubt there's much you can do from your client to
prevent that (if that is the case). There may be a way to turn off
oplocks on the server side, but that may very well be even worse for
performance.

-- 
Jeff Layton <jlayton@redhat.com>
