Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZF3WTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZF3WTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZF3WTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:19:39 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:11837 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbZF3WTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:19:38 -0400
X-Spam-Processed: digidescorp.com, Tue, 30 Jun 2009 17:19:41 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.151.134.50
X-Return-Path: prvs=1432024fb5=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FAT: optimize FSINFO writeback
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87ocs5h238.fsf@devron.myhome.or.jp>
References: <1246392130-4261-1-git-send-email-steve@digidescorp.com>
	 <87ocs5h238.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Tue, 30 Jun 2009 17:19:05 -0500
Message-Id: <1246400345.2247.4.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 05:57 +0900, OGAWA Hirofumi wrote:
> steve@digidescorp.com writes:
> 
> > Only write the FSINFO block back to disk when its contents change.
> > This optimization can be important when the underlying physical media
> > can wear out, i.e. Flash.
> 
> I have no objection to this though.  Was this tested on recent version?

I tested it on 2.6.30.

> Well, now, we are using sb->s_dirty for fsinfo, so I'm wondering why
> this happen frequently.

My scenario was modifying a sector of an existing file and using
fdatasync() to flush it. The FSINFO sector was being updated even though
nothing about the FAT layout had changed.

> 
> Thanks.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


