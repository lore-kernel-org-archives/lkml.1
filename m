Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZJ2Snu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZJ2Snu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 14:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZJ2Snu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 14:43:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35782 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbZJ2Snt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 14:43:49 -0400
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, LKLM <linux-kernel@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Lon Hohberger <lhh@redhat.com>, Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH] [RFC][Patch x86-tip] add notifier before kdump
References: <4AE6B1CC.6040603@np.css.fujitsu.com>
	<20091027150725.GD10513@redhat.com>
	<4AE949A5.9080509@np.css.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 29 Oct 2009 11:43:49 -0700
In-Reply-To: <4AE949A5.9080509@np.css.fujitsu.com> (Jin Dongming's message of "Thu\, 29 Oct 2009 16\:52\:05 +0900")
Message-ID: <m11vkm11ne.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jin Dongming <jin.dongming@np.css.fujitsu.com> writes:

> Hi Vivek
>
> Vivek Goyal wrote:
>> - Other thing, I think Eric Biederman suggested was that we need to see
>>   the code that will be executed after crash so that it can be audited and
>>   keep it in kernel instead of blindly exporting a hook to module and let
>>   module do whatever it want to do.
>> 
>
> I am sorry for that I could not catch the meaning of above words. In my
> understanding:
>     If the code is already in current kernel and no matter whether it is built
>     or modulized, the code could be added before crash_kexec. Is it right?

No.  crash_kexec skips the calling the notifiers intentionally to increase
it's robustness.

> If my understanding is not right, please let me ask a question before we
> provide the code.
>     What kind of code is considered as nice code and could be added into
>     current kernel? Could you give me some requirements or examples
>     about nice code?

In general code that is necessary.  If we can find a way to avoid running
code in a broken kernel we should.

The recent addition of code to disable processor vitalization features
on a crash is an example of code that is necessary.  A small function
that we can always call that is not provided by a module.

Eric
