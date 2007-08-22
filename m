Return-Path: <linux-kernel-owner+w=401wt.eu-S932499AbXHVSy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbXHVSy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761127AbXHVSyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:54:21 -0400
Received: from empbedex1.empirix.com ([12.38.203.54]:5121 "EHLO
	empbedex1.empirix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762873AbXHVSyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:54:20 -0400
X-Greylist: delayed 973 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 14:54:20 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: NFS/RPC Hangs after updating time...
Date: Wed, 22 Aug 2007 14:37:22 -0400
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D90108F975FB@EMPBEDEX.empirix.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: NFS/RPC Hangs after updating time...
Thread-Index: Acfk63oF49kAy+KLQXaklISLZ3XJCw==
From: "Morrison, Tom" <tmorrison@empirix.com>
To: <nfs@lists.sourceforge.net>
Cc: <linux-kernel@vger.kernel.org>, "Rushton, Matt" <Mrushton@empirix.com>
X-OriginalArrivalTime: 22 Aug 2007 18:38:04.0634 (UTC) FILETIME=[937E8BA0:01C7E4EB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I've got an unusual problem with a corner case that I 
am investigating. I've tried 'googling' around to 
find if someone has discussed this before, but 
I have yet to find any discussion close to this - 
so I bring it to your collective minds...

I am working with a 2.6.11++ kernel on an embedded 
server platform that is NFS serving Linux rootfs 
for other embedded NFS Client boards.

Everything works fine when the system time on the 
server board is relatively synchronized with the real-time. 

It hangs after attempting to update the time from a 
nonsensical time (e.g.: 2 months ago) - the most significant
part of it is that it only hangs IFF it has started 
serving its NFS client boards before I attempt to 
update the time.


The most significant output (when turning on 
RPC debugging) is from:

  linux/net/sunrpc/cache.c (cache_check) - line 90:

         >> Want update, refage=1800, age=4288285

It continually loops through this method - and the cache
never gets updated...even thought with some additional
sleuthing (aka: additional debug printks - it thinks 
that there is an cache update pending).

Thanks for any ideas you have on this subject.

Sincerely,

      
         
         

Tom Morrison
Principal S/W Engineer
Empirix, Inc (www.empirix.com)
tmorrison@empirix.com
(781) 266 - 3567
 
 
