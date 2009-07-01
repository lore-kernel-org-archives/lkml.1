Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZGANNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZGANNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZGANMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:12:52 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:24835 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZGANMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:12:51 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 09:12:50 EDT
X-Spam-Processed: digidescorp.com, Wed, 01 Jul 2009 08:07:35 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1433facca9=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FAT: optimize FSINFO writeback
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <873a9hfdqz.fsf@devron.myhome.or.jp>
References: <1246392130-4261-1-git-send-email-steve@digidescorp.com>
	 <87ocs5h238.fsf@devron.myhome.or.jp>
	 <1246400345.2247.4.camel@iscandar.digidescorp.com>
	 <873a9hfdqz.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Wed, 01 Jul 2009 08:07:03 -0500
Message-Id: <1246453623.2260.4.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 09:28 +0900, OGAWA Hirofumi wrote:
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> >> Well, now, we are using sb->s_dirty for fsinfo, so I'm wondering why
> >> this happen frequently.
> >
> > My scenario was modifying a sector of an existing file and using
> > fdatasync() to flush it. The FSINFO sector was being updated even though
> > nothing about the FAT layout had changed.
> 
> I see. Probably, I'm missing something, or handling of sb->s_dirt may be
> buggy, or something.
> 
> If it was fixed, is this patch still needed?  I guess this patch would
> still be useful on some case though.  If you can explain, it would be
> good.

It is I who am missing something. The patch originated against a 2.6.20
kernel, where it does indeed suppress unnecessary updates. I saw the
same code in the 2.6.30 kernel and assumed the same issue was present,
and tested that with the patch present there were no unnecessary
updates. It appears that there are no unnecessary updates even _without_
the patch, so I withdraw it.

> 
> Thanks.

Thanks for looking at this so carefully.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


