Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbXD1QGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbXD1QGp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbXD1QGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:06:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:57047 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbXD1QGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:06:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Ega7HPbKiQdSiyZKqKU0rxRQJaLkXqamohpTVopbxCMe8bHYEs7I8Z6yVSaAUerwek7v5yRZT9Kqw7Kxll9rq+2F935BxZn9OF1TS+a6/ZW071vFU+kp01CE85oXrF0M86VwtXKDuTVQw46XeBctXcL3W0Eyo5i7EBF8QlDvt54=
Message-ID: <4633710A.7080508@gmail.com>
Date: Sun, 29 Apr 2007 01:06:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, maneesh@in.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] sysfs: sysfs rework, take #2
References: <Pine.LNX.4.44L0.0704281026400.29437-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704281026400.29437-100000@netrider.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sat, 28 Apr 2007, Tejun Heo wrote:
> 
>> Subject: [PATCHSET] sysfs: sysfs rework, take #2
>>
>> Hello, all.
>>
>> This is respin of syswork rework patchset in gregkh patch series.
>> Changes are...
> 
> ...
> 
>> All the known regrssions are fixed.  I think I've got all the
>> attr->owner but haven't verified with cross compiling yet, just
>> allyesconfig on x86-64 and i386.  I'll try to setup some cross compile
>> environments tomorrow and follow up if I can find more fallouts.
> 
> What have you done about the problem of device nodes getting unregistered
> while the corresponding sysfs directory is non-empty, say with child
> device directories still present?

That was a problem because the previous update of sysfs_drop_dentry()
depended on walking from the root of /sys to the associated dentry to
drop it - which is quite nice because all dentry management can be
isolated.  I tried fixing it by 1. deferring drop of dentry till all its
children are gone (last child kills the deferred parent) 2. recursively
dropping all children when the parent is deleted (later drop of the
child becomes noop) but they both can't work with shadow directories, so
I gave up on the approach and just made synchronization around
sd->s_dentry correct.  So, it's not an issue anymore.  Verified to work.

Thanks.

-- 
tejun
