Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbZAFXx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbZAFXx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZAFXxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:53:34 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:60038 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZAFXxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:53:33 -0500
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Matt Helsley <matthltc@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
Message-Id: <8BC8AF03-457C-4B26-9500-955F91A8A60E@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <1231284943.8041.8.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
Date: Tue, 6 Jan 2009 18:51:55 -0500
References: <20090106011314.534653345@us.ibm.com> <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com> <1231274682.20316.65.camel@heimdal.trondhjem.org> <20090106215831.GE18147@us.ibm.com> <m1eizg11fy.fsf@frodo.ebiederm.org> <1231283734.8041.6.camel@heimdal.trondhjem.org> <20090106233238.GD13785@fieldses.org> <1231284943.8041.8.camel@heimdal.trondhjem.org>
X-Mailer: Apple Mail (2.930.3)
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4963EE9F.0119:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 6, 2009, at Jan 6, 2009, 6:35 PM, Trond Myklebust wrote:
> On Tue, 2009-01-06 at 18:32 -0500, J. Bruce Fields wrote:
>> On Tue, Jan 06, 2009 at 06:15:34PM -0500, Trond Myklebust wrote:
>>> On Tue, 2009-01-06 at 15:04 -0800, Eric W. Biederman wrote:
>>>> That implies to me you want to capture the value at mount time,  
>>>> and to
>>>> pass it in to the rpc_call creation, and only at very specific well
>>>> defined points where we interact with user space should we examine
>>>> current->utsname().  At which point there should be no question
>>>> of current->utsname() is valid as the user space process is alive.
>>>
>>> Why pretend that the filesystem is owned by a particular  
>>> namespace? It
>>> can, and will be shared among many containers...
>>
>> If the only purpose of this is to fill in the auth_unix cred then
>> shouldn't it be part of whatever cred structures are passed around?
>
> So how does tracking it in a shared structure like the rpc_client  
> help?
> If you consider it to be part of the cred, then it needs to be tracked
> in the cred...

I think generating a proper AUTH_SYS cred, given the existence of  
containers, is the essential question here.

However, we use nodename for lock owners too... perhaps that deserves  
a separate solution.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
