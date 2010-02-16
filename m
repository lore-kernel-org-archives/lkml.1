Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab0BPPkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:40:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39057 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab0BPPkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:40:20 -0500
Date: Tue, 16 Feb 2010 16:39:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: ketchup was Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100216153905.GA1541@ucw.cz>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <1265988318.24271.30.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265988318.24271.30.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I wouldn't worry too much about breaking the current locations. Just
> > give some time for software authors (ketchup comes to mind) to update
> > their code and it shouldn't be a big problem.
> 
> As the new maintainer of ketchup:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/ketchup.git
> 
> I could write a fix for the new format real quick. My concern is that
> users of ketchup may not see this update for a long time.

I'd really like to fix ketchup to behave sanely in late -rc stages:
going from -rc6 to -rc8 is possible using two downloads through --rc7
(like 100KB?)  instead of two big ones through full release (like
10MB).

But first step is --only-dl option -- when you want to cache the
needed patches but not apply anything yet.

Please apply,
									Pavel

diff --git a/ketchup b/ketchup
index 0728aec..3249cbc 100755
--- a/ketchup
+++ b/ketchup
@@ -405,7 +405,7 @@ def apply_patch(ver, reverse = 0):
         r = " -R"
 
     qprint("Applying %s%s" % (os.path.basename(p), r))
-    if options["dry-run"]:
+    if options["dry-run"] or options["only-dl"]:
         return ver
 
     def cmd(patch, reverse, dry):
@@ -484,7 +484,7 @@ def install_nearest(ver):
         ver = list[0][2]
 
     qprint("Unpacking %s" % os.path.basename(f))
-    if options["dry-run"]: return ver
+    if options["dry-run"] or options["only-dl"]: return ver
     untar(f)
 
     return ver
@@ -658,6 +658,7 @@ opts = [
     ('l', 'list-trees', None, 'list supported trees'),
     ('m', 'show-makefile', None, 'output version in makefile <arg>'),
     ('n', 'dry-run', None, 'don\'t download or apply patches'),
+    ('o', 'only-dl', None, 'don\'t apply patches'),
     ('p', 'show-previous', None, 'output version previous to <arg>'),
     ('q', 'quiet', None, 'reduce output'),
     ('r', 'rename-directory', None, 'rename updated directory to %s<v>'
@@ -750,7 +751,7 @@ if not a and os.listdir("."):
 b = find_ver(args[0])
 qprint("%s -> %s" % (a, b))
 transform(a, b)
-if options["rename-directory"] and not options["dry-run"]:
+if options["rename-directory"] and not options["dry-run"] and not options["only-dl"] :
     rename_dir(b)
 
 if postcommand and os.system(postcommand):

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
