Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbZF1NDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbZF1NDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZF1NC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:02:59 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:45303 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZF1NC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <m17hyw1s0h.fsf@fess.ebiederm.org>
References: <20090626143652.GB6281@localdomain.by> <20090626144949.GA24173@suse.de> 
	<20090626232339.GD3858@localdomain.by> <m18wjeqven.fsf@fess.ebiederm.org> 
	<20090627093932.GB3342@localdomain.by> <1246147018.24693.97.camel@yio.site> 
	<m17hyw1s0h.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 28 Jun 2009 15:02:46 +0200
Message-ID: <ac3eb2510906280602j1812d7e7qce874d2e9775e29e@mail.gmail.com>
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 14:07, Eric W. Biederman<ebiederm@xmission.com> wrote:

> But setting a kobject's name several times in a row is a bug.  You
> need to call kobject_rename if you are going to change the name.

Sure, we can define in that way.

> So how about we fix the driver core not to do that.  Stop treating fmt
> as a flag, and make it clear kobject_add should not be passed a name.

Sounds fine to me. You did not try to compile your patch, right? :)

block/blk-sysfs.c: In function ‘blk_register_queue’:
block/blk-sysfs.c:436: error: implicit declaration of function ‘kobj_set_name’

drivers/base/driver.c: In function ‘driver_add_kobj’:
drivers/base/driver.c:149: error: too many arguments to function ‘kobject_add’

Documentation/kobject.txt would also need an update then.

Thanks,
Kay
