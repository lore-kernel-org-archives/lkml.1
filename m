Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbXLIAVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbXLIAVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXLIAVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:21:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:65064 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbXLIAVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:21:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BCZCxdzTplGWx+BjbfvaqCyJ9m9deSKzv6hcFc/b7C+LLwdP/aFlZizfy1uCcvhfG9wf7YMeslJZoTQPqaUU3DOdfJ2cYYONwpj2uKbzEZb/llppJbtK82GPNYAEth7REMPD6SZkPn8eJfNqKw7R4n+2ZFiIZ6MNQxMYUcrXmYo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Date: Sun, 9 Dec 2007 02:20:44 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Denis V. Lunev" <den@openvz.org>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com> <20071207151444.af5d8e11.akpm@linux-foundation.org> <200712080043.29292.rjw@sisk.pl>
In-Reply-To: <200712080043.29292.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712090220.44543.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 December 2007 01:43:28 Rafael J. Wysocki wrote:
> On Saturday, 8 of December 2007, Andrew Morton wrote:
> > On Fri, 07 Dec 2007 17:51:58 -0500
> > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > 
> > > On Fri, 2007-12-07 at 14:39 -0500, Shane wrote:
> > > > On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
> > > > ...
> > > > > Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> > > > > spots and check for other regressions.
> > > > 
> > > > Hmm, I installed a new kernel built from the same sources on the NFS
> > > > server. And now I don't see anything at all in the crossmnt dirs.
> > > > 
> > > > ls /dirA/dirB/dirC  --> zero output (empty dir)
> > > > 
> > > > Are there any other pending fixes?

Hi,
Due to the fact that I was bitten by this bug (I thought it is a feature), and a bit of lack
of understanding of NFS4 I want to ask few questions about NFS:

1) I want to export whole file-system  with submounts to a range of clients.
As 'exports' manual says I can't do so, is that true?

Can you tell me how properly to use crossmnt and nohide?
Where should I put those options in root file-system export or in submount export?

2) NFS4 - I can't get it working:

*I have a LFS system, and this is what I did (NFS3 works fine, but crossmnt, and nohide seems not to work, probably due to above bug)
	I also have seen errors about stale handles 
*Kernel - 2.6.24-rc3 with NFS3/4 client/server enabled on both host and guest. (both client and server running this kernel)
*rpc.idmapd running on both client and server + all standard NFS3 tools
*NFS tools 1.1.1 with nfs4 support compiled + without GSS (on server)
* /etc/exports with fsid=0: (on server)
	/tmp *(fsid=0,insecure,rw,async,anonuid=100,anongid=1000)
* mounting with -tnfs4 server:/ /mnt/tmp

Still doesn't work, using wireshark shows that
	NFSV4 COMPOUND call with
		Opcode: PUTROOTFH (24)
		Opcode: GETFH (10)
		Opcode: GETATTR (9)

Fails with 
	Reject State: AUTH_ERROR (1)
	Auth State: bad credential (seal broken) (1)


Any ideas?

(I decided to switch to NFS4 only due to the lack of ability to see underlying mounts)

The system I am connecting to is a very old P1 system I use as a terminal
(X and ssh)
When I need to install something there I mount whole / of in on my main Core2 system
chroot there, and compile/install.


Best regrads,
	Maxim Levitsky
