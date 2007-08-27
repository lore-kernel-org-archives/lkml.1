Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbXH0UIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbXH0UIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbXH0UIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:08:22 -0400
Received: from mail.reagi.com ([195.60.188.80]:58659 "EHLO mail.reagi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799AbXH0UIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:08:21 -0400
Message-ID: <46D32F2F.3050408@oxeva.fr>
Date: Mon, 27 Aug 2007 22:08:15 +0200
From: Gabriel Barazer <gabriel@oxeva.fr>
Organization: OXEVA
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Al Viro <viro@ftp.linux.org.uk>, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jkar8572@users.sourceforge.net
Subject: Re: nfs4 filesystem mounted via the "bind" option reports wrong	fstype
References: <46D318D3.9020101@oxeva.fr> <20070827184059.GI3118@fieldses.org> <20070827191507.GI21089@ftp.linux.org.uk> <20070827193242.GJ3118@fieldses.org>
In-Reply-To: <20070827193242.GJ3118@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2007 9:32:42 PM +0200, "J. Bruce Fields" <bfields@fieldses.org> 
wrote:
> On Mon, Aug 27, 2007 at 08:15:07PM +0100, Al Viro wrote:
>> On Mon, Aug 27, 2007 at 02:40:59PM -0400, J. Bruce Fields wrote:
>>  
>>> There's no reason not to just mount server:/exports/data directly at
>>> /home/data; the bind mounts are just a workaround for the somewhat
>>> primitive exports facility on the server side.
>> Bullshit.  Bindings are first-class operations on _client_, regardless
>> of fs types involved.
> 
> I know.  Did I say something to the contrary?
> 
> Maybe I was too terse; in more detail: the original poster appears to be
> mounting server:/exports/data by first mounting server:/ somewhere and
> then bind-mounting the exports/data someplace else.  I couldn't see an
> obvious reason they'd be using two steps instead of just performing a
> single mount of server:/exports/data.
> 
> So my assumption was that this was due to a confused memory of some
> server-side setup instructions. (On the server side, nfs4 export setup
> often requires the administrator to do some extra bind mounts which
> shouldn't really be necessary.)

Right. When setting up the clients, I remembered these "bind" mount 
things, and applied the same client-side because at this time I had 
other bugs for which I thought "bind" mount was the solution. In fact 
it's not, but as nfs4 is seen as a unique filesystem and I had several 
exported volumes, It was easier to mount the nfsv4 pseudoroot, then 
"bind" mount all the volumes from it.

But the bug's still here, and since these additional mounts appear 
"magically" in /proc/mounts, I don't know where to look at in the kernel 
source. The nfsv4 client code must have somewhere a kind of nfs4 
automounter for "nohide" volumes. A bit ugly IMHO, but the only way to 
show quotas for separates nfsv4 exported volumes too.

Gabriel
