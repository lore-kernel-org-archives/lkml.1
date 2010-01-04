Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941Ab0ADXEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0ADXEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638Ab0ADXEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:04:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:57544 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab0ADXEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:04:42 -0500
Message-ID: <4B427547.5070109@kernel.org>
Date: Tue, 05 Jan 2010 08:09:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <m11victac1.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>	<m1fx6rtu31.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>	<m17hs0xjmn.fsf@fess.ebiederm.org> <4B3FE586.7020109@kernel.org>	<20100103074745.GA2314@core.coreip.homeip.net>	<m1tyv3sbg4.fsf@fess.ebiederm.org>	<20100104185755.GB2597@core.coreip.homeip.net> <m14on1fygh.fsf@fess.ebiederm.org>
In-Reply-To: <m14on1fygh.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/05/2010 04:43 AM, Eric W. Biederman wrote:
>>> So it is unlikely but possible to deadlock by accessing a serio
>>> attribute of a serio device that is being removed.
>>
>> Hmm, I guess I was too quick dismissing lockdep complaints here. Now
>> that sysfs remove waits deadlock indeed is possible. Actually the locks
>> on serio->drv_mutex in attributes were added to make sure we don't
>> access device that was unbound from the driver through stale sysfs
>> attributes.
> 
> Cool.  So we have solved the problem generically but we have left over
> layer specific solutions.  That seems like a good problem to have.

This is way too cool.  Only if we can have more moments like this.  :-)

-- 
tejun
