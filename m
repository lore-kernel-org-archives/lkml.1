Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbZFVUmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbZFVUmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZFVUm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:42:29 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:57891 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZFVUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:42:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19007.60396.259650.682653@stoffel.org>
Date: Mon, 22 Jun 2009 16:39:08 -0400
From: "John Stoffel" <john@stoffel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: Re: Fix for shared flat binary format in 2.6.30
In-Reply-To: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
References: <4A3F5EAE.7020402@t-online.de>
	<alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> On Mon, 22 Jun 2009, Bernd Schmidt wrote:
>> 
>> This fixes a crash in 2.6.30 with shared flat binaries.  prepare_binfmt now
>> requires a cred pointer to be set up, which isn't done in binfmt_flat.c.

Linus> This has so many bugs in patch submission that I literally
Linus> almost gave up despite it being a trivial patch.

I just recently submitted a patch, and it took me a while to figure
out a git flow for stupid, simple patches so that I, a moron, could
understand it.  Here's what I've documented.  Maybe it should be added
to Documentation/SubmittingPatches so that people like me, who only
rarely use git for anything, can use it to submit stuff properly?

###################################################################
# References
http://linux.yyz.us/git-howto.html
http://www.kernel.org/pub/software/scm/git/docs/git-format-patch.html
http://www.kernel.org/pub/software/scm/git/docs/git-send-email.html


# One time commands
> apt-get install git-email
> git config --global user.name "John Stoffel"
> git config --global user.email "john@stoffel.org"

# Only to be done infrequently
> mkdir /var/tmp/git-tree
> cd /var/tmp/git-tree
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6



# Make a new branch <branch> for the patch you're doing.  In this
  case, we'll do 'sym_hipd-ratelimit'

> git checkout -b sym_hipd-ratelimit

# Now edit the file

> vi drivers/scsi/sym53c8xx_2/sym_hipd.c
> git commit -a

# Put in a simple message of a line or two.

    ratelimit parity error reporting, which helps alot on bootup over serial
    console when you get 10,000+ lines of this message.

# Now exit the editor

# Check the commit, which is the most recent one by default

> git log -1

# See the actual patch with:

> git diff master..HEAD

# Make a patch you can send out, including any CC: and the signoff (-s)

> git format-patch --cc=linux-scsi@vger.kernel.org --cc=stable@kernel.org -s
0001-ratelimit-parity-error-reporting-which-helps-alot-on.patch

# Now look the patch over and see if you need to edit the subject or
# anything

# In this case, I don't like the commit message
vi 0001-ratelimit-parity-error-reporting-which-helps-alot-on.patch

# Now do a dry run to send the email
> git send-email --dry-run --to=linux-kernel@vger.kernel.org 0001-ratelimit-parity-error-reporting-which-helps-alot-on.patch

# Looks good, send for real
> git send-email --to=linux-kernel@vger.kernel.org 0001-ratelimit-parity-error-reporting-which-helps-alot-on.patch


# Cleanup, got back to the main branch and merge in our change, just
# for fun

> git branch master
> git merge sym_hipd-ratelimit


