Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbYJVXEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbYJVXEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 19:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYJVXEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 19:04:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35711 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYJVXEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 19:04:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       netdev <netdev@vger.kernel.org>, Dave Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Denis Lunev <den@openvz.org>,
       Linux Containers <containers@lists.linux-foundation.org>
References: <20081022152144.351965414@theryb.frec.bull.fr>
	<m1d4hso0ym.fsf@frodo.ebiederm.org> <20081022203045.GA4633@us.ibm.com>
	<m18wsgmji0.fsf@frodo.ebiederm.org> <20081022145507.2d1ea86c@extreme>
Date: Wed, 22 Oct 2008 15:54:23 -0700
In-Reply-To: <20081022145507.2d1ea86c@extreme> (Stephen Hemminger's message of
	"Wed, 22 Oct 2008 14:55:07 -0700")
Message-ID: <m11vy8jl5s.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Hemminger <shemminger@vyatta.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0010]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/4][RFC] netns: sysfs: add a netns suffix to net device sysfs entries
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@vyatta.com> writes:

>> The well-known user space tools don't use /sys at all.  Modern
>> network tools use rtnetlink (ip) old network tools use /proc/net.
>> 
>> Very few things actually use /sys and for those things lo@1 or
>> eth0@1 are completely useless except for implementing a FUSE
>> mock up of sysfs.  But you don't need anything in sysfs to do
>> that as all of the interesting information is available through
>> /proc/net or rtnetlink.
>
> Lots of scripts are starting use /sys for things. It is easier to
> parse /sys/class/net than the output of ifconfig or ip 

Yes.  So we need the correct values in /sys/class/net.

Which is why sysfs and network namespaces do not coexist currently.

Which is why I recommend only placing devices in the initial network
namespace in sysfs for the short term.

Which is why we need to get all of the details correct when we
handle multiple network namespaces and sysfs.

I should have something working and should be sending patches out
shortly.  Cleaning up sysfs and the device model enough so the changes
are not spooky is a long hard road unfortunately.

Eric
