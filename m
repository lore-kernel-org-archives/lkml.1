Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbYJWSAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbYJWSAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYJWSAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:00:38 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:55022 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbYJWSAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:00:36 -0400
Message-ID: <4900BB0E.9000303@cs.columbia.edu>
Date: Thu, 23 Oct 2008 13:57:34 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: crispin@crispincowan.com
CC: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [TOMOYO #11 (linux-next) 01/11] Introduce new LSM hooks where
 vfsmount is available.
References: <20081020073423.024299308@nttdata.co.jp>	<20081020073643.986810046@nttdata.co.jp> <48FC7938.1070906@cs.columbia.edu> <20081020193428.8k6ottvjfc1woscw@webmail8.dotsterhost.com> <48FCF6CA.2060406@cs.columbia.edu>
In-Reply-To: <48FCF6CA.2060406@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaya Potter wrote:
> crispin@crispincowan.com wrote:
>> Quoting Shaya Potter <spotter@cs.columbia.edu>:
>>> I know I'm late to the game in this, but as I recently asked about this
>>> and didn't get an answer, I'll re-ask my approach.
>>>
>>> Why can't you do this
>>>
>>> in lookup()
>>>
>>> - resolve rules (not for single process, but for all processes) for
>>> said path and tag dentry (seem to already have a hook)
>>>
>>> in permission()
>>
>> Because it doesn't work 
>> http://kerneltrap.org/mailarchive/linux-fsdevel/2007/6/8/319446
>>
>> Quick summary: The difference between the pathname model and the label 
>> model is dynamism. The accessi really is determined by the pathname to 
>> the file that you used to access the file. If you try to compute 
>> access based on attributes tagged onto the file, then you have to 
>> re-compute those attributes every time someone renames a file.
> 
> ok.  simple question then so why not just recompute them every every 
> rename?  are rename's that common relative to all other file operations 
> where we care?

just want to followup as didn't get a response.  If the problem is 
rename(), what's the problem with dropping the label on rename() to 
force a reevaluation on the next pass through the lookup() code.
