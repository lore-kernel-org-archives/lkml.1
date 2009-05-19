Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZESMWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZESMWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZESMWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:22:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZESMWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:22:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Date: Tue, 19 May 2009 14:21:20 +0200
User-Agent: KMail/1.9.9
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz,
       vaurora@redhat.com
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <200905191354.08701.arnd@arndb.de> <20090519121504.GO16526@bolzano.suse.de>
In-Reply-To: <20090519121504.GO16526@bolzano.suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905191421.21026.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19LUlAw4b3riuFD0VfTfQOjeM90AshTOe0MW0r
 L79F1+7IavQ4yLCcGFyNC1y6h3JALg5WItuCxyCyWxPZhM0NVt
 +g31V8En7cqXc1ftXcSMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009, Jan Blunck wrote:
> On Tue, May 19, Arnd Bergmann wrote:
> > This would work, but you'd have to do this for each file system if you want
> > to be able to use it as the top of the union while backed by a read-only
> > block device or when you don't want it to be written.
> 
> I know that the requirement for the topmost filesystem to be able to create
> directories and fill them with fallthrus is an unattractive one. On the other
> hand this is the cost that you have to pay at the moment to get this kind of
> functionality. This implementation will not help with all use-cases. Its focus
> is to get certain use-cases right.

So what would go wrong if you only made them persistent for writable file
systems, but allowed fallthrough dentries to be discarded for read-only
file systems? As long as the lower layers don't change, you should still
be able to reconstruct the same dentries every time you do a readdir, right?

	Arnd <><
