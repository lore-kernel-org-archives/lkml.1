Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbXC2CEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbXC2CEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 22:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933972AbXC2CEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 22:04:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:39716 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933963AbXC2CEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 22:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Eb6WPAfRXUOE7Qofkro00Q/CpSXFVgiyPFKA5OQ6sWiCnmPDVKYpgFzjV3TSOfNLLumanCnegsaJwUpilH5TdImpIrm4bcV41+XthoZ9i/wSxiaTr3f21GwVwJ/qbTmzzKXzGZzybmBW2r/yHkB58DpF9Y4jXoFMsH7NLN++tTQ=
Message-ID: <460B1EAF.8030207@gmail.com>
Date: Thu, 29 Mar 2007 11:04:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [patch 2/3] libata: expose AN support to user space via sysfs
References: <20070328230108.597741522@intel.com> <20070328164450.b89d5156.kristen.c.accardi@intel.com>
In-Reply-To: <20070328164450.b89d5156.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Allow user space to determine if an ATAPI device supports
> async notification (AN) of media changes.  This is done by
> adding a new sysfs file "async_notification" to genhd.
> If the file reads 1, then the device supports async 
> notification.  If the file reads 0, it does not.  
> 
> A flag is set in the generic disk to indicate whether
> or not AN is supported.  This flag is set by the SCSI
> subsystem when it registers with add_disk.  The SCSI
> system gets information from libata on whether the
> device supports AN during dev_configure. 

I'm not sure whether this should be in generic block layer or in libata 
proper.  libata sysfs hierarchy isn't there yet but is scheduled to be 
added soon.  Async notification of media change is generic event for any 
block device with removable media, so I guess it can belong to generic 
layer.  BTW, I think you also need to forward the flag in sd - disk 
device can be removable too.  And please cc linux-scsi@vger.kernel.org 
to get SCSI part reviewed.

Thanks.

-- 
tejun
