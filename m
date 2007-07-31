Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbXGaVRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbXGaVRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbXGaVRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:17:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36619 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbXGaVRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:17:23 -0400
Message-ID: <46AFA6AB.8080208@oracle.com>
Date: Tue, 31 Jul 2007 17:16:27 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture, Linux Projects Group
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       kzak@redhat.com, sfrench@samba.org, trond.myklebust@fys.uio.no,
       mark.fasheh@oracle.com, kurt.hackel@oracle.com
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu> <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu> <46AE01C2.3000008@oracle.com> <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu> <46AF450D.5020106@oracle.com> <E1IFyEK-00042c-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1IFyEK-00042c-00@dorka.pomaz.szeredi.hu>
Content-Type: multipart/mixed;
 boundary="------------020005000805050905090400"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020005000805050905090400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Miklos Szeredi wrote:
>>>> After a successful mount, the NFS mount command tucks some options into 
>>>> /etc/mtab that reflect which mountd was used for the mount, and what 
>>>> protocol version and port was used for the mount request.  Those options 
>>>> are not passed to the kernel, and do not appear in /proc/mounts today. 
>>>> See nfs(5)'s discussion of the mountport, mounthost, mountprog, and 
>>>> mountvers options.
>>>>
>>>> However, the trend for NFS is to push mount option parsing into the 
>>>> kernel.  Thus all options will be passed to the kernel, and at that 
>>>> point it should be able to reflect the mount* options in /proc/mounts. 
>>>> But it doesn't do that quite yet.
>>> Trond, do you have a roadmap for this?
>> Well I'm actually doing the coding, and Trond is playing more of an 
>> architectural role.
> 
> OK, what your estimage for this then?

I don't have an estimate.  This is all very slippery because once I get 
into a part of the code, we discover a lot of issues that we didn't 
expect.  The NFS mount stuff is largely historical; we've all forgotten 
(or never really knew) how it works.

> It would be nice to have all this stuff in 2.6.24, which doesn't leave
> a lot of time.

Yes, that would be nice, but there's a lot of stuff that needs to get 
done before this.  NFS IPv6, for example, is a higher priority than 
refactoring to remove /etc/mtab -- the US government has a new 
requirement in 2008 for IPv6 support in any software that it purchases, 
and NFS may be a stumbling block for distributors if it doesn't have it.

So I'd say "no way" for 2.6.24, but it's really Trond's call to make.

> But if it's just those four options you mentioned, it should be
> managable.  I do not think there needs to be some generic code to
> hande userspace-only options, it would be perfectly fine just to
> parse, store and show them like all the other options.

Like you, I don't expect it will be difficult to implement, but I have 
too many balls in the air to make any promises at the moment.  Plus, we 
can't really predict when distributors will feel the in-kernel mount 
parsing stuff will be ready for their users.

--------------020005000805050905090400
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel
version:2.1
end:vcard


--------------020005000805050905090400--
