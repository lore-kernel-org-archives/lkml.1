Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbYESSAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbYESSAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbYESR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:59:55 -0400
Received: from mail.mindmedia.com.sg ([210.193.7.34]:56392 "EHLO
	mail.mindmedia.com.sg" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011AbYESR7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:59:54 -0400
Message-ID: <4831C016.8000207@singnet.com.sg>
Date: Tue, 20 May 2008 01:59:50 +0800
From: "P.V.Anthony" <pvantony@singnet.com.sg>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: Re: Solved - How to change the FSINFO for nfsd?
References: <482332CD.4010706@singnet.com.sg> <20080509042238.GC21408@fieldses.org> <20080518015733.o7n8cvhomvgos8ow@mail.mindmedia.com.sg> <alpine.LNX.1.10.0805172024440.15590@fbirervta.pbzchgretzou.qr> <1211049402.7498.4.camel@localhost> <20080519172412.GL7622@fieldses.org>
In-Reply-To: <20080519172412.GL7622@fieldses.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Sat, May 17, 2008 at 02:36:42PM -0400, Trond Myklebust wrote:
>> On Sat, 2008-05-17 at 20:25 +0200, Jan Engelhardt wrote:
>>> On Saturday 2008-05-17 19:57, P.V.Anthony wrote:
>>>> resp->f_properties = NFS3_FSF_DEFAULT;
>>>>
>>>> nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
>>>> @@ -570,7 +570,7 @@
>>>> if (sb->s_magic == 0x4d44 /* MSDOS_SUPER_MAGIC */) {
>>>> resp->f_properties = NFS3_FSF_BILLYBOY;
>>>> }
>>>> - resp->f_maxfilesize = sb->s_maxbytes;
>>>> + resp->f_maxfilesize = 0xffffffffffffffff;
>>    This is plain wrong! Pretending that your filesystem supports 64-bit
>> files won't magically make it so.
> 
> Yes.  Could you tell us what filesystem you're using?
> 
> It's a bit bizarre that this would fix anything; I'd think the more
> likely result would be errors on write and/or some kind of file
> corruption.

The filesystem used is ext3. So far no file corruption. The os is 64bit
gentoo.

Will be trying xfs without the patch and will report back. I think XFS
is 64bit and will see if Mac OS X with Final Cut Pro works with it.

Please not that the problem only happens when using the video editing
application Final Cut Pro. Without the patch, when capturing video to
the mounted NFS, the captured video is broken into 2Gb size files. This
is even when the server and client is set to version 3.

The old version of FCP does not have this behaviour.

I am guessing that Apple is some way forcing people to buy their Xserve
servers. To use their servers for NFS.

If a file is dragged on to the NFS mount then it will work fine. It only
does not work through the FCP application. Like when capturing or
exporting to a NFS mount.

P.V.Anthony


