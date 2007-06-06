Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbXFFRe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbXFFRe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763951AbXFFReu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:34:50 -0400
Received: from raven.upol.cz ([158.194.120.4]:62629 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763429AbXFFRet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:34:49 -0400
Date: Wed, 6 Jun 2007 19:45:56 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Another version of cleanfile/cleanpatch (Re: [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines)
Message-ID: <20070606174556.GS7266@flower.upol.cz>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org> <20070605145759.GP7266@flower.upol.cz> <20070605151101.GQ7266@flower.upol.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070605151101.GQ7266@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

While i'm against whitespace damaged files or patches since my very
first patch, and don't like brain damaged programmer's tools called
text editors, i also want to encourage UNIX-way of using userspace.

Of course, i might be wrong and foolish. Anyway, what i'm trying to do
is not to become new generation of Visual Perl#(R) implemented in
Java(R) using XML with userspace, that suck.

Many things in XXI century still can be done by tools founded 20-30
years ago. Why not try to?

Here is script proposal and test case, just for interested parties.
--
-o--=O`C  info emacs : faq
 #oo'L O  info make  : not found
<___=E M  man gcc    : not found

--0vzXIDBeUiKkjNJl
Content-Type: application/x-sh
Content-Disposition: attachment; filename="clean-whitespace.sh"
Content-Transfer-Encoding: 8bit

#!/bin/sh -e
# clean whitespace damage; i/o = $1/$1.clean

IFS='' ; t="`printf '\t'`" ; s=' ' ; s4="$s$s$s$s" ; w79=79 ;
i="$1" ; o="$1.clean"
strip_file_end='/^$/{N;s_^\n$_&_;T e;:n;N;s_^.*\n\n$_&_;t n;:e;};'
not_patch_line='/^+[^+]/'

case $0 in *diff* | *patch*)
	file=patch ; sp='+[!+]' ; p='+' ; addr="$not_patch_line" ;;
esac

sed -n "${addr:-$strip_file_end} {
s|[$t$s]*$||; # trailing whitespace,
:next;        # x*8 spaces on the line start -> x*tabs
s|^$p\($t*\)$s4$s4|$p\1$t|;t next;
s|^$p\($t*\)$s*$t|$p\1$t|g; # strip spaces between tabs
};p" -- "$i" >"$o" &&
echo "please, see clean ${file:=source} file: $o
"
exec expand $i | while read -r line # check for long line
do   [ ${#line} -gt $w79 ] && case "$line" in $sp*) echo \
"at least one line wider than $w79 chars, found;
check your $file, please
" 1>&2 ; exit ;; esac
done

--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="clean-whitespace.test"

# last spaces must NOT be striped to two tabs
	 tabspace    spaces	   	tab spaces tab
# trailing tabs mixed with spaces
				   	
                2x8 spaces, must be 2xtabs
	    	tab spaces tab, bust be 2 tabs

# more trailing whitespace
bar     


## Automatically generated incremental diff
## From:   linux-2.6.21-rc4
## To:     linux-2.6.21-rc5
## Robot:  $Id: make-incremental-diff,v 1.12 2004/01/06 07:19:36 hpa Exp $

--- linux-2.6.21-rc4/Documentation/kernel-parameters.txt	2007-03-25 23:12:16.654792317 +0000
# dont strip trailing whitespace
+++ linux-2.6.21-rc5/Documentation/kernel-parameters.txt	2007-03-25 23:12:21.243287617 +0000          
@@ -138,6 +138,12 @@

-	int gpio_direction_output(unsigned gpio);
# tab space tab -> tab tab, strip trailing whitespace
+	    	int gpio_direction_output(unsigned gpio, int value);	  
 
 The return value is zero for success, else a negative errno.  It should
 be checked, since the get/set calls don't have error returns and since
 misconfiguration is possible.  (These calls could sleep.)
# dont touch space
 
+  tester, add space for wide line  ... vided becomes the initial output value.

# end of file, must be one new line
efwef






--0vzXIDBeUiKkjNJl--
