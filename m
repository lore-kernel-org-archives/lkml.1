Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbYLLV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbYLLV5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbYLLVzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:55:38 -0500
Received: from M4.sparta.com ([157.185.61.2]:33483 "EHLO M4.sparta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbYLLVzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:55:36 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2008 16:55:35 EST
Message-ID: <4942DCA5.60109@sparta.com>
Date: Fri, 12 Dec 2008 16:50:29 -0500
From: "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: James Morris <jmorris@namei.org>, hch@infradead.org,
       viro@zeniv.linux.org.uk, casey@schaufler-ca.com, sds@tycho.nsa.gov,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 03/14] LSM/SELinux: inode_{get,set,notify}secctx hooks
 to access LSM security context information.
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>	 <1227733394-1114-4-git-send-email-dpquigl@tycho.nsa.gov>	 <alpine.LRH.1.10.0812052052480.14142@tundra.namei.org> <1228490712.15920.45.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1228490712.15920.45.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2008 21:51:48.0005 (UTC) FILETIME=[D504B550:01C95CA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> On Fri, 2008-12-05 at 20:58 +1100, James Morris wrote:
>> On Wed, 26 Nov 2008, David P. Quigley wrote:
>>
>>> + * @inode_getsecctx:
>>> + * 	Returns a string containing all relavent security context information
>>> + *
>>> + * 	@inode we wish to set the security context of.
>>> + *	@ctx is a pointer in which to place the allocated security context.
>>> + *	@ctxlen points to the place to put the length of @ctx.
>>>   * This is the main security structure.
>>>   */
>>>  struct security_operations {
>>> @@ -1479,6 +1514,10 @@ struct security_operations {
>>>  	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
>>>  	void (*release_secctx) (char *secdata, u32 seclen);
>>>  
>>> +	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
>>> +	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
>>> +	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
>> For inode_getsecctx(), you're returning the length via the return value, 
>> so you should not also need to pass in a pointer to ctxlen, right?
>>
>> IMHO, it's clearer and simpler to always only return error status from 
>> these kinds of functions, and to pass things like size back via pointer 
>> args, although it seems that a few mixed return functions have crept in to 
>> the code over time.  My preference would be to convert it to return value 
>> is error status only, with the length entirely separate as a pointer arg.
>>
>>
>> - James
> 
> I'll have to look into why we did it this way. The discussion for these
> patches happened many months ago so I don't remember why it was done
> this way. I remember at the time getting an approval for the approach
> but a desire not to merge the patch while there were no users of it.

I think it was a result of inode_getsecctx() being a wrapper for 
selinux_inode_getsecurity() which returns a length.
