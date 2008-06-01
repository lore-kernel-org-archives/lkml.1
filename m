Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYFAJgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYFAJgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYFAJgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:36:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35986 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYFAJgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:36:03 -0400
Date: Sun, 1 Jun 2008 10:36:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: make drm use create_proc_read_entry() instead
Message-ID: <20080601093600.GL28946@ZenIV.linux.org.uk>
References: <20080531203940.40536c9a@infradead.org> <20080531214821.19218b6b@infradead.org> <20080601092546.GA4967@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601092546.GA4967@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 01:25:46PM +0400, Alexey Dobriyan wrote:
> On Sat, May 31, 2008 at 09:48:21PM -0700, Arjan van de Ven wrote:
> > Subject: [PATCH] drm: make drm use create_proc_read_entry() instead
> > 
> > Al Viro points out that DRM should have used create_proc_read_entry(),
> > and although that is still racey right now, it at least has a chance
> > of getting fixed on the api level.
> 
> Fix on API level is proc_create_data(), so this patch is pointless.

Yeah...  OTOH, it might make sense to reorder assignments in the
create_proc_read_entry() and slap the barrier in there - it would
close at least some of the holes until we get around to proper
proc_create_data() conversions and remove the ->read_proc() crap...
