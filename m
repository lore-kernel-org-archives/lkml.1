Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYBXK4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYBXK4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 05:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYBXK4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:56:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:62818 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYBXK4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:56:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC 02/11] introduce simple_fs_type
Date: Sun, 24 Feb 2008 11:55:52 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
References: <20080219040435.825494460@arndb.de> <20080219040828.690045213@arndb.de> <20080223122859.GN27894@ZenIV.linux.org.uk>
In-Reply-To: <20080223122859.GN27894@ZenIV.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241155.53861.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+5mpTQKTKADCt+Ch9PIOiM0qqT7imu0RwcPNt
 Wlq1KR94Mxo0EP1yIg3DtF4AltSS9pd8fFpNeUx2PYwUWxwZKO
 HJ/CcSpYNVCCQV74RsMHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008, Al Viro wrote:
> On Tue, Feb 19, 2008 at 05:04:37AM +0100, Arnd Bergmann wrote:
> > The most interesting function here is the new "struct dentry *
> > simple_register_filesystem(struct simple_fs_type *type)", which
> > returns the root directory of a new file system that can then
> > be passed to simple_create_file() and similar functions as a
> > parent.
> 
> Don't mix "split the file" with "add new stuff", please. 

Ok, I'll introduce it in libfs.c first then.

> And frankly, I'm not convinced that embedding file_system_type
> into another struct is a good idea.

Right, that has been one of the areas I've been thinking about
myself without coming to a good solution. One alternative I
thought about is to have the news members as part of file_system_type
itself, but that would cost a bit of memory for every single 
file system, and might lead to unintended misuse of these members
by non-simple file systems.

Do you think it would be better to dynamically allocate the
file_system_type and have a pointer in struct simple_fs_type to
it?

	Arnd <><
