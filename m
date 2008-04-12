Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYDLTea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYDLTea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYDLTeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:34:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40359 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYDLTeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:34:22 -0400
Message-ID: <48010C70.2030902@zytor.com>
Date: Sat, 12 Apr 2008 12:24:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Multiple instances of devpts
References: <20080412172933.GA19295@us.ibm.com>	 <20080412183514.GO9785@ZenIV.linux.org.uk>  <48010583.3020403@zytor.com> <1208027757.28187.25.camel@x61.ebiederm.org>
In-Reply-To: <1208027757.28187.25.camel@x61.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>
>> /dev/ptmx can be a symlink ptmx -> pts/ptmx, and we add a ptmx instance 
>> inside the devpts filesystem.  Each devpts filesystem is responsible for 
>> its own pool of ptys, with own numbering, etc.
>>
>> This does mean that entries in /dev/pts are more than just plain device 
>> nodes, which they are now (you can cp -a a device node from /dev/pts 
>> into another filesystem and it will still "just work"), but I doubt this 
>> actually matters to anyone.  If anyone cares, now I guess would be a 
>> good time to speak up.
> 
> Agreed.   That is another legitimate path.  And if all you care about is
> isolation and not dealing with the general class of problems with the
> global device number to device mapping that is sane.  I know we have
> several other virtual devices that we tend to care about but ptys are
> the real world pain point.
> 

Thinking about it further, allowing this restriction would also allow a 
whole lot of cleanups inside the pty setup, since it would eliminate the 
need to do a separate lookup to find the corresponding devpts entry in 
pty_open().  The benefit here comes from the closer coupling between the 
pty and the devpts filesystem and isn't at all related to namespaces, 
but it's a very nice side benefit.

	-hpa
