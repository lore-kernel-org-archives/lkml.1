Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbXJISzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbXJISzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXJISzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:55:07 -0400
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:46130
	"EHLO schlidder.svs.informatik.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbXJISzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:55:06 -0400
X-Greylist: delayed 1264 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2007 14:55:06 EDT
Date: Tue, 9 Oct 2007 20:33:59 +0200
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NTFS error messages: replace static char pointers by
	static char arrays
Message-ID: <20071009183359.GB3945@titan.lahn.de>
Mail-Followup-To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <470AA75E.7010508@gmail.com> <20071009124035.GA4245@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009124035.GA4245@Ahmed>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Tue, Oct 09, 2007 at 02:40:35PM +0200, Ahmed S. Darwish wrote:
> On Tue, Oct 09, 2007 at 01:55:42AM +0400, Dmitri Vorobiev wrote:
> > The patch below contains a small code clean-up for the NTFS driver: all
> > static char pointers to error message strings have been replaced by 
> > static char arrays.

      char *       a = "a"; // pointer and content can be changed
const char *       b = "b"; // the thing pointed to is const
      char * const c = "c"; // the pointer is const
const char * const d = "d"; // pointer and content can't be changed

void foo(void) {
        *a = 'A';
        a++;
        *b = 'B'; // error: assignment of read-only location
        b++;
        *c = 'C';
        c++;      // error: increment  of read-only variable 'c'
        *d = 'D'; // error: assignment of read-only location
        d++;      // error: increment  of read-only variable 'd'
}

> Isn't the only difference between char *c = "msg" and char c[] = "msg" is 
> that the first is a non-const pointer to a const char array while the second 
> is a modifiable char array ?

$ cat [ab].c
const char *a = "a";
const char b[] = "b";
$ gcc -c [ab].c
$ size [ab].o
   text    data     bss     dec     hex filename
      2       4       0       6       6 a.o
      2       0       0       2       2 b.o

'a' has two entries: one for the named read-writeable pointer, and one for the
    anonymous read-only string, the pointer points to.
'b' has a single entry: just the named read-only string.

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
