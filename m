Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYAVSIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYAVSIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYAVSIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:08:07 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:52184 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbYAVSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:08:05 -0500
X-Greylist: delayed 1973 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 13:08:05 EST
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86] please setup git for http access
Date: Tue, 22 Jan 2008 09:34:52 -0800
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
References: <200801151556.58881.joachim.deguara@amd.com>
 <478D5D13.70904@zytor.com> <200801171443.56750.joachim.deguara@amd.com>
In-Reply-To: <200801171443.56750.joachim.deguara@amd.com>
MIME-Version: 1.0
Message-ID: <200801220934.53224.joachim.deguara@amd.com>
X-OriginalArrivalTime: 22 Jan 2008 17:32:30.0779 (UTC)
 FILETIME=[C3EFA8B0:01C85D1C]
X-WSS-ID: 6B88F6A40QK8485373-13-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008, Joachim Deguara wrote:
> On Tuesday 15 January 2008, H. Peter Anvin wrote:
> > Joachim Deguara wrote:
> > > Hello,
> > >   I am trying to access the x86 git tree behind a proxy and therefore
> > > over the http address.  This works for Linus' tree but not for the x86
> > > tree.  Please follow these guidelines to enable http access.
> > >
> > > http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#export
> > >in g-via-http
> >
> > Set up now.
> >
> > 	-hpa
>
> Thanks but unfortunately it still seams not to be working.  I cannot
> sucessfully:
>  git-clone
> http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>
> I can see the git repository over http but I am guessing something did not
> go right with 'git --bare update-server-info' as the .git/info directory
> does not have the refs like Linus' does which are needed for http (gleaming
> this from man git-update-server-info).  There have been updates to the git
> tree since you responded so it looks like that hook did not get activated. 
> (these are guesses from me and I don't really know git well so don't trust
> a word I say)
>
> thanks
> -Joachim

Its almost works now!  It starts cloning the archive but then does not find 
a 'pack'.  Interestingly there are not many packs populated:
http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git/objects/pack/

joachim@andante:git> git clone 
http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
Initialized empty Git repository in /home/joachim/tmp/git/linux-2.6-x86/.git/
Getting alternates list for 
http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
Also look at 
http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
Getting pack list for 
http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
Getting index for pack 467c9a27b7553e8ad01fc42a6fbe74965e32ec4e
Getting index for pack ec3b53b28a0be9cc6121d29c327f5945a1aeeb8e
Getting pack ec3b53b28a0be9cc6121d29c327f5945a1aeeb8e
 which contains 4960c9df1407c2723459c60ff13e6efe0c209c62
walk 4960c9df1407c2723459c60ff13e6efe0c209c62
walk d384e35a25445bb60457b7dab8cffe178c6b7ecb
Getting pack list for 
http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
error: Unable to find 8d14531846b95bfa3564b58ccfb7913a034323b8 under 
http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
Cannot obtain needed blob 8d14531846b95bfa3564b58ccfb7913a034323b8
while processing commit d384e35a25445bb60457b7dab8cffe178c6b7ecb.
Waiting for 
http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git/objects/41/12e840094b6d3f5e280c83466c66d267fced99
Waiting for 
http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git//objects/e9/4ba7819ccceacdda2c2f0f72017c543b4b6808
Waiting for 
http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git/objects/a9/d4836f7003159bf56607eeb1b78775b548cfa1
joachim@andante:git> echo $?
1


-Joachim


