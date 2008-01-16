Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYAPRet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYAPRet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYAPRef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:34:35 -0500
Received: from ns.firmix.at ([62.141.48.66]:2304 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYAPRed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:34:33 -0500
Subject: Re: Why is the kfree() argument const?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Christoph Lameter <clameter@sgi.com>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi
In-Reply-To: <Pine.LNX.4.64.0801160831490.8188@schroedinger.engr.sgi.com>
References: <87lk6pvii0.fsf@saeurebad.de>
	 <Pine.LNX.4.64.0801160831490.8188@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 16 Jan 2008 18:34:25 +0100
Message-Id: <1200504865.21186.59.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.102 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.102 required=5
X-Spam-Score: -1.102 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2008-01-16 at 08:48 -0800, Christoph Lameter wrote:
> On Wed, 16 Jan 2008, Johannes Weiner wrote:
> 
> > is there any reason why kfree() takes a const pointer just to degrade it
> > with the call to slab_free()/__cache_free() again?  The promise that the
> > pointee is not modified is just bogus in this case, anyway, isn't it?
> 
> The object is modified in various cases f.e. because of poisoning or the 
> need to store the free pointer. So its bogus, yes. Pekka?

Technically one should be able to pass a "const $type *" (which may
have been a "non-const $type *" before but at some point in time it
became "const $type *") to kfree().

The (formerly) constant contents as such vanishes IMHO (and it is not
really "modified").
Poisoning and free memory handling is IMHO internal stuff to the free
memory management subsystem and basically unrelated to the "life" of the
pointered contents before it's death with kfree().

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


