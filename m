Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZJAO6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZJAO6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZJAO6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:58:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52385 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbZJAO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:58:47 -0400
Subject: Re: [PATCH 1/1] Kobject: bail early if no new_parent in
	kobject_move()
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
Reply-To: ext-phil.2.carmody@nokia.com
To: ext Greg KH <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091001144933.GA4222@suse.de>
References: <>
	 <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
	 <20091001144933.GA4222@suse.de>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Thu, 01 Oct 2009 18:01:50 +0300
Message-Id: <1254409310.32640.459.camel@pcarmody-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2009 14:58:23.0427 (UTC) FILETIME=[9F5F3930:01CA42A7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 16:49 +0200, ext Greg KH wrote:
> On Thu, Oct 01, 2009 at 05:50:48PM +0300, Phil Carmody wrote:
> > From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > 
> > In the absense of kobj->kset, new_parent would remain NULL.
> > NULL-dereference shenanighans then ensues in the subsequent
> > sysfs_move_dir(..., new_parent) call. Bail early instead.
> 
> What caller causes this to happen?

It was spotted by static code analysis. If there's no such path, 
then the ``if (kobj->kset)'' condition itself would be unnecessary.

Phil
-- 
"They weren't designed to run on a computer, they were designed
to run on a Powerpoint slide projector." -- Peter Gutmann

