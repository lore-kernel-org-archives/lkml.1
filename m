Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZEMOUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZEMOUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZEMOUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:20:24 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38129 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbZEMOUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905130634l75ef8f78v604c53fb4bc3167f@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com> <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil> 
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> 
	<1242132344.31807.48.camel@localhost.localdomain> <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com> 
	<1242142528.31807.80.camel@localhost.localdomain> <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com> 
	<1242168913.6711.9.camel@poy> <10761.1242220810@redhat.com> 
	<ac3eb2510905130634l75ef8f78v604c53fb4bc3167f@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 13 May 2009 16:20:02 +0200
Message-ID: <ac3eb2510905130720x38de25adxc83b10aea0b86ce1@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: David Howells <dhowells@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 15:34, Kay Sievers <kay.sievers@vrfy.org> wrote:

>>> +     kern_cred = prepare_kernel_cred(NULL);
>>
>> If you have no intention of altering the credentials you create, you might
>> want to use &init_cred instead of kern_cred.  That said, you might want to
>> allocate it and let the security module alter it before you use it.
>
> Ah, didn't know that it was exported. It's the one in
> include/linux/init_task.h, right? I'll give that a try.

That seems to work fine here. Thanks a lot for the help.

Maybe we could do the same credential swap in sysfs, and get rid of:
/**
 * lookup_one_noperm - bad hack for sysfs
 * @name:       pathname component to lookup
 * @base:       base directory to lookup from
 *
 * This is a variant of lookup_one_len that doesn't perform any permission
 * checks.   It's a horrible hack to work around the braindead sysfs
 * architecture and should not be used anywhere else.
 *
 * DON'T USE THIS FUNCTION EVER, thanks.
 */

in fs/namei.c?

Seems a bit odd to have a vfs function for a single filesystem, called
from a single location, and annotated as "do not use". Christoph added
the comment a while ago, so adding him to Cc:.

Thanks,
Kay
