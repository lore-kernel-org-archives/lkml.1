Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbYHFDAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbYHFDAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761030AbYHFDAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:00:41 -0400
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:46258 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760860AbYHFDAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:00:40 -0400
X-YMail-OSG: LaEQC.MVM1moy2K42NwJvUAgrO7bVHFM62lC7R467Y0LdXMrTrP7Gf9uTmPYB1EwWaICPI_ObD5azv2fBvf9R6ghwMuwxZf1bhkHTssSBzkHZSa3tsTa.W.ByFFDy6l3k7c-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <489913CF.1010708@schaufler-ca.com>
Date: Tue, 05 Aug 2008 20:00:31 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: Cliffe <cliffe@ii.net>, Eric Paris <eparis@redhat.com>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
References: <1217883616.27684.19.camel@localhost.localdomain> <4897C2A7.7020601@ii.net> <4897CC9C.2090906@schaufler-ca.com> <200808051656.28231.paul.moore@hp.com>
In-Reply-To: <200808051656.28231.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Monday 04 August 2008 11:44:28 pm Casey Schaufler wrote:
>   
>> Cliffe wrote:
>>     
>>> Other security schemes such as intrusion detection,
>>> firewalls/netfilter, anti-malware, and application restrictions
>>> (sandboxes such as jails or finer grained restrictions such as
>>> AppArmor) could all register LSMs onto the stack.
>>>       
>> Stacking is easy for files. It's a real pain in the backside for UDP
>> packets.
>>     
>
> How is it any better/worse for UDP packets than files?
>   
On delivery you'd need to decide what security scheme is actually
available on the packet and in what order to interpret any inbound
security data. If you had an MLS scheme that uses CIPSO, an integrity
mechanism using IPSEC and a DAC scheme that assigns user ids by
host address getting the ordering right and every domain registered
properly in the networking stack would be a trick. Plus, making sure
that any state the security scheme requires is tricky. Maybe it's not
actually worse if the schemes agree on what qualifies as a security
element, but if one scheme does access control outbound while another
does inbound it will get hairy.

