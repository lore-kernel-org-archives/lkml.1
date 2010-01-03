Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969Ab0ACGDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab0ACGDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 01:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880Ab0ACGDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 01:03:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:36854 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0ACGDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 01:03:52 -0500
Message-ID: <4B4033AF.9050101@kernel.org>
Date: Sun, 03 Jan 2010 15:05:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>	<20091226094504.GA6214@liondog.tnic>	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>	<m11victac1.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>	<m1fx6rtu31.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>	<m17hs0xjmn.fsf@fess.ebiederm.org> <4B3FE586.7020109@kernel.org>	<m1ws00uel9.fsf@fess.ebiederm.org> <4B4024A5.1020704@kernel.org> <m1ljgfvjcy.fsf@fess.ebiederm.org>
In-Reply-To: <m1ljgfvjcy.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/03/2010 02:38 PM, Eric W. Biederman wrote:
>> How about simply introducing an interface to mark sysfs nodes which
>> don't require active reference counting and using them on those nodes?
> 
> That might work.  However it does not seem to address the case of
> bond_sysfs, especially with someone doing rmmod bonding.

Ah... okay, now I remember this.  Yeah, I ripped off module ref
counting from sysfs ops.  I completely forgot about that and was
thinking we still had module ref counting on sysfs ops.  The logical
thing to do would be restoring module ref counting on sysfs ops which
won't go through active ref counting.  ie. Let the interface which
switch off active ref counting require module owner so that it uses
module ref counting instead of active ref counting.

Thanks.

-- 
tejun
