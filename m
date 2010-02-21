Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0BUNxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 08:53:53 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47781 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751976Ab0BUNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 08:53:51 -0500
Date: Sun, 21 Feb 2010 14:53:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ketchup was Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100221135341.GC1307@ucw.cz>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <1265988318.24271.30.camel@gandalf.stny.rr.com> <20100216153905.GA1541@ucw.cz> <1266337061.24271.138.camel@gandalf.stny.rr.com> <20100216162745.GA1660@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216162745.GA1660@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-02-16 17:27:45, Pavel Machek wrote:
> Add --only-dl option -- when you want to cache the needed patches but
> not apply anything yet.

Actually, you'll probably get a better patch if you relace 'only-dl'
with just 'dl'. Mistaking --only-dl and --dl-only is just too easy.

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/ketchup b/ketchup
> index 0728aec..3249cbc 100755
> --- a/ketchup
> +++ b/ketchup
> @@ -405,7 +405,7 @@ def apply_patch(ver, reverse = 0):
>          r = " -R"
>  
>      qprint("Applying %s%s" % (os.path.basename(p), r))
> -    if options["dry-run"]:
> +    if options["dry-run"] or options["only-dl"]:
>          return ver
>  
>      def cmd(patch, reverse, dry):
> @@ -484,7 +484,7 @@ def install_nearest(ver):
>          ver = list[0][2]
>  
>      qprint("Unpacking %s" % os.path.basename(f))
> -    if options["dry-run"]: return ver
> +    if options["dry-run"] or options["only-dl"]: return ver
>      untar(f)
>  
>      return ver
> @@ -658,6 +658,7 @@ opts = [
>      ('l', 'list-trees', None, 'list supported trees'),
>      ('m', 'show-makefile', None, 'output version in makefile <arg>'),
>      ('n', 'dry-run', None, 'don\'t download or apply patches'),
> +    ('o', 'only-dl', None, 'don\'t apply patches'),
>      ('p', 'show-previous', None, 'output version previous to <arg>'),
>      ('q', 'quiet', None, 'reduce output'),
>      ('r', 'rename-directory', None, 'rename updated directory to %s<v>'
> @@ -750,7 +751,7 @@ if not a and os.listdir("."):
>  b = find_ver(args[0])
>  qprint("%s -> %s" % (a, b))
>  transform(a, b)
> -if options["rename-directory"] and not options["dry-run"]:
> +if options["rename-directory"] and not options["dry-run"] and not options["only-dl"] :
>      rename_dir(b)
>  
>  if postcommand and os.system(postcommand):
> 
> 
> diff --git a/ketchup.1 b/ketchup.1
> index 0a313ee..9e5a385 100644
> --- a/ketchup.1
> +++ b/ketchup.1
> @@ -1,5 +1,5 @@
>  .\"                                      Hey, EMACS: -*- nroff -*-
> -.TH KETCHUP 1 "April 12, 2006"
> +.TH KETCHUP 1 "February 16, 2010"
>  .\" Please adjust this date whenever revising the manpage.
>  .\"
>  .\" Some roff macros, for reference:
> @@ -74,6 +74,11 @@ output version in makefile <arg>
>  .IP
>  don't download or apply patches
>  .HP
> +.B \-o
> +.B \-\-only\-dl
> +.IP
> +don't apply patches
> +.HP
>  .B \-p
>  .B \-\-show\-previous
>  .IP
> 
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
