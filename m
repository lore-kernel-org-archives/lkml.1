Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYCNPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYCNPQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYCNPQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:16:32 -0400
Received: from sacred.ru ([62.205.161.221]:52868 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYCNPQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:16:31 -0400
Message-ID: <47DA94CE.9090101@openvz.org>
Date: Fri, 14 Mar 2008 18:07:58 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
References: <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au> <20080313224616.GA9139@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au> <20080314014121.GA8320@sergelap.austin.ibm.com> <47DA4533.8030106@openvz.org> <20080314135817.GE8744@sergelap.austin.ibm.com> <47DA861A.2020905@openvz.org> <20080314143752.GE9741@sergelap.austin.ibm.com>
In-Reply-To: <20080314143752.GE9741@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 14 Mar 2008 18:08:00 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

>> The # of rules usually has a linear dependency on the number of containers
>> (each of then has to have an access to /dev/null,zero,random at least), so
>> having 100 containers we will have to scan through a 300-entries list.
> 
> Oh no, the rules are stored per-container, so it sounds like you're
> saying 3 entries per container?

Oops :) I've missed that part :(

>> I'd
>> vote for a hash table or a radix/binary/rb tree for that. Or any other way
>> for non-linear search you can provide :)
> 
> I'm fine with that, but not for 3 rules  :)

So am I :) Anyway - if someday this will grow up to tens of entries turning
it into a more scalable lookup would be easy.

> -serge
> 

