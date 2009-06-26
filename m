Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbZFZTXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbZFZTXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZFZTW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:22:59 -0400
Received: from mail.samba.org ([66.70.73.150]:40997 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZFZTW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:22:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19013.8206.743747.14716@samba.org>
Date: Sat, 27 Jun 2009 05:22:54 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: FAQ on 2nd VFAT patch
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the feedback from the first patch, we have put together a
short FAQ that tries to address the kinds of questions that were
raised during that discussion. The Linux Foundation has organized for
a patent attorney, John Lanza, to be available to answer legal
questions that come up, to the extent that he is able to. John is CCd
on this email.

Cheers, Tridge

------

Q1.  Has this patch undergone legal review?

A1.  Both the original patch and the new patch that we posted today
     have been through legal review by several lawyers who specialize
     in this area.  We can't post all of the details of those reviews,
     but John Lanza is CCd on this email, and hopefully he will be
     able to answer any questions that arise or if he can't answer
     some question he may be able to explain why he can't answer
     it. John is a patent attorney who represents the Linux
     Foundation.


Q2.  What can we safely post on LKML about patent infringement?

A2.  Almost nothing.  Even a statement of the form "If A were the case,
     then B would result in infringement of patent C" is extremely
     dangerous.  It allows a patent attorney to argue that truth or
     falsity of A is a legal question of fact, even if A is an obvious
     technical fallacy (remember that the patent holder can call on
     its own expert witnesses).  The existence of a legal question of
     fact can be used to defeat a pre-trial summary judgment motion
     for noninfringement and dismissal of the lawsuit.  The defeat of
     pre-trial summary judgment motions results in the suit going to
     trial, which is always quite expensive.  The patent holder can be
     expected to choose a target that cannot afford a trial, resulting
     in a settlement or capitulation.  The patent holder can then use
     the fact that target #1 settled to apply more pressure on targets
     #2, #3, and so on.

     This can happen even if you later clearly state that A is an
     obvious technical fallacy.  The patent holder would just say
     something like, "Your Honor, J. Random Hacker admitted that B is
     the case, and we will prove that he was mistaken when he later
     retracted that admission and tried to claim that A was an obvious
     technical fallacy.  We will demonstrate, by Mr. Hacker's own
     words, that our valuable patent C is in fact infringed."  The
     patent holder might well lose that point later at trial, but only
     if the target can afford to go to trial in the first place.

     In short, anything posted on LKML is on the public record and can
     therefore be read and archived and used by patent holders to
     convince a judge to dismiss summary judgment motions in order to
     threaten a costly trial and try to force a settlement.


Q3.  Why should we apply a patch to avoid a patent that might be invalid?

A3.  It takes a lot of time in the courts (and thus, a lot of money)
     to legally prove that a patent is invalid, and in the meantime
     the patent remains at least a nuisance and in practice still
     dangerous.  Any damage done during this time period, to both
     persons and organizations, might well be permanent -- it might
     never be possible to repair that damage, even if the patent
     should eventually be invalidated.  On the other hand, a patch
     that avoids both the patent and regressions in function and
     performance can greatly reduce the danger of such damage.

     One of the specific dangers that needs to be addressed is
     illustrated by the ITC action that Microsoft took against TomTom:

         http://www.itcblog.com/20090227/microsoft-files-new-337-complaint-against-tomtom-regarding-certain-portable-navigation-devices/

     That ITC action asked for TomTom's products to be seized at US
     borders, and might have effectively shutdown TomTom as a going
     concern in the US. If Microsoft did the same thing to another
     Linux vendor then even though the vendor might eventually win
     they could still be severely damaged just by having their market
     disrupted or frightened.

     The way to avoid this is to ensure that the Linux kernel is so
     obviously non-infringing that the case does not even go to trial.
     That means you have to have an extremely clear explanation of how
     the patent does not apply to your code. The aim of the patches we
     have posted is to ensure that we would meet that standard.


Q4.  Suppose we accept such a patch.  How do we deal with the
     possibility that future bug fixes undo the patch?

A4.  This is a very real concern.  In this case, I hope that the
     explanation below provides Hirofumi-san the information needed to
     avoid this possibility.  If some future patch looks to him like
     it might re-introduce the problem, he could check with one of the
     people who submitted this patch.

     This is similar to what a subsystem maintainer does when they
     check with the owner of some exotic piece of hardware whether a
     proposed patch would break the kernel on that hardware.


Q5.  Why do you believe that this patch avoids the patent?

A5.  It is not appropriate for us to provide the full details of the
     legal reasoning on a public forum, but we can sketch out some
     facts here which may be helpful. Then if you have any more
     specific questions you can direct them to John Lanza. You should
     note that this sketch is not a legal opinion, because legal
     opinions are given to direct clients, not to a public forum like
     lkml.

     The claims of both of the VFAT patents "create" or "store" a long
     filename entry. The first patch we posted changed the code so
     that long filename entries are never created or stored. That
     patch left unchanged the code for reading long filename entries,
     and so the patch kept the functionality of reading existing long
     filenames. The result is a patch that loses some functionality
     (creating or storing long filenames), but did no creating or
     storing of long filenames.

     The 2nd patch we just posted takes a different approach. The
     claims of both of the VFAT patents involve the creation (or
     storing) of both a long filename and a short filename for a file.
     The 2nd patch only creates/stores either a short filename or a
     long filename for a file, but never both. The 11 bytes created by
     vfat_build_dummy_83_buffer() to pad the field for short filenames
     cannot be used to access the file, and contain bytes which are
     invalid in FAT and VFAT filenames, and therefore are not
     filenames as that term is and has been used in the technical
     community.


Q6.  Why the random values for the field in which the short filename
     would normally be stored?

A6.  The patch includes some comments that explain why we chose those
     particular byte values. Basically we needed to minimise the
     chance of triggering a bug in WindowsXP where some values would
     cause XP to crash with a blue screen (Vista and Windows7 do not
     seem to have this bug). The values were also chosen to have a
     quite low chance of causing any problems with chkdsk.exe on
     Windows.


Q7.  What if I need to access the files with an old version of DOS
     or Windows that does not understand long filenames?

A7.  In this case, you can use the msdos filesystem to enforce 8.3
     format names.  We believe that these old versions are
     sufficiently rare that this is not a real concern.


Q8.  The first patch was configured off by default, while this patch
     is configured on by default.  Why the difference in behavior?

A8.  The first patch disabled significant function, while this new
     patch allows all the filenames allowed by the VFAT format.  If
     accepted, it is of course up to the maintainers to decide what
     the default should be in mainline, or even if the patch should be
     unconditional.  We are happy with any of these three choices
     (configurable default disabled, configurable default enabled, or
     unconditionally disabled).
