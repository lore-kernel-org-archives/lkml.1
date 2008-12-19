Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYLSTxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYLSTxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYLSTxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:53:38 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38781 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYLSTxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:53:37 -0500
In-Reply-To: <12342.1229711059@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Muntz, Daniel" <Dan.Muntz@netapp.com>, dhowells@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       nfsv4@linux-nfs.org, rwheeler@redhat.com, sfr@canb.auug.org.au,
       steved@redhat.com
MIME-Version: 1.0
Subject: Re: Pull request for FS-Cache, including NFS patches
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF4F5F89AF.8F313531-ON88257524.006A611A-88257524.006D49B8@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Fri, 19 Dec 2008 11:53:38 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_10262008HFIGS1|October
 26, 2008) at 12/19/2008 14:53:35,
	Serialize complete at 12/19/2008 14:53:35
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Muntz, Daniel <Dan.Muntz@netapp.com> wrote:
> 
> > AFS was designed to support local disk cache, so with callbacks 
> you can get a
> > consistent system.
> 
> It's less the callbacks and more the data version number that's 
important.

Maybe for consistency, but for the performance benefits of local disk 
caching, I believe the callbacks are pretty important.  I say that because 
I regularly use an NFS 3 filesystem on the IBM internal network that is 
painfully slow on Linux and fine on AIX with CacheFS.  It was also fine 
when this data was in AFS instead, and if I copy all the files to a local 
disk filesystem.

In this case, the files are _all in local page cache_, so I assume the 
waiting is for the constant stream of transactions the client uses to make 
sure the data in the cache is still current every time I open a file.  AIX 
CacheFS doesn't sweat the consistency, so makes these queries only 
periodically.  AFS had the callbacks, so rather than the client asking 
every time if the data had changed, the server just told it when it did.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Storage Systems

