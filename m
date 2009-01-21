Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbZAUJN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbZAUJN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZAUJNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:13:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55662 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZAUJNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:13:09 -0500
Date: Wed, 21 Jan 2009 10:28:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       hannes@saeurebad.de
Subject: Re: emacs indenting howto
Message-ID: <20090121092820.GF15750@one.firstfloor.org>
References: <alpine.DEB.2.00.0901191521270.2904@bikeee> <87fxjddys0.fsf@basil.nowhere.org> <alpine.DEB.2.00.0901211145370.4514@bikeee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901211145370.4514@bikeee>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 11:49:29AM +0300, Dan Carpenter wrote:
> On Wed, 21 Jan 2009, Andi Kleen wrote:
> >Dan Carpenter <error27@gmail.com> writes:
> >
> >>I don't think emacs understands tilda expansion.  It didn't work for me.
> >
> >It does when you use expand-file-name
> >
> >-Andi
> 
> No problem.  Here is the updated patch.

FWIW this is what I use. It turns on linux-c-mode for anything with
linux in the path name. While that occasionally mis-hits, it only
does seldom.

(defvar is-emacs20 (if (string-match "2[0-9]\\." emacs-version) t nil))

(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  ;; grr - still does not seem to work properly
  (make-variable-buffer-local 'tab-width)
  (make-variable-buffer-local 'c-basic-offset)
  (c-mode)
;  (if window-system
;         (change-mode 'passive))
  (make-variable-buffer-local 'version-control)
  (setq version-control 't)
  (c-set-style (if is-emacs20 "linux" "K&R")) 
  (setq tab-width 8)
  (setq c-basic-offset 8))

(push '(".*/linux.*/.*\\.[ch]\\'" . linux-c-mode) auto-mode-alist)
(push '(".*/linux.*/.*\\.[ch]\\(-[a-z]+\\)?\\'" . linux-c-mode) auto-mode-alist)

I also have that one but it's probably obsolete by now:

(defun reiserfs-c-mode () 
  "Hide silly ifdefs for reiserfs" 
  (interactive)
  (linux-c-mode) 
  (setq  hide-ifdef-initially t) 
  (hide-ifdef-mode 1)
  (hide-ifdef-define '__KERNEL__)
  (hide-ifdef-define 'REISERFS_PREALLOCATE) 
  (hide-ifdef-undef 'CONFIG_REISERFS_CHECK)
  (hide-ifdef-undef 'REISERFS_CHECK))

(push '(".*/linux.*/fs/reiserfs/[^/]+\\.[ch]\\'" . reiserfs-c-mode) auto-mode-alist)


-Andi

