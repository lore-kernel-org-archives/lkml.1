Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXFYNsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXFYNsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXFYNr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:47:57 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:22648 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbXFYNr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:47:56 -0400
Subject: Documentation of kernel messages (Summary)
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, kunai@linux-foundation.jp,
       tim.bird@am.sony.com, gh@us.ibm.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, hpa@zytor.com,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       rob@landley.net, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
In-Reply-To: <20070613111549.db1fa4d9.akpm@linux-foundation.org>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM
Date: Mon, 25 Jun 2007 15:48:41 +0200
Message-Id: <1182779321.7142.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Any idea, how to proceed with this topic? Do you think that any of the
suggested solutions for documentation / translation of kernel messages
will have a chance to be included in the kernel?

I tried to summarize the outcome of this discussion...

There are two main issues:

* Translate messages
* Document messages

For both, we have to give messages identifiers in order to match them
to the corresponding documentation / translation. Three possible
solutions have been suggested:

1. Use message numbers maintained by driver owners
2. Automatically create hashes for printks
3. Use printk format string as message identifier

Regarding the question where to put documentation and translations we
have two options:

* In the kernel tree
* Somewhere outside the kernel tree

Another issue of the discussion was the usage of the component name for
printks.

Useful comments:
================
Andrew Morton:
Suggested an alternative approach using a new printk function with
message ID parameter. Documentation / Translation should be done
outside the kernel.

Gerrit Huizenga:
Suggested an alternative approach using hashes as message IDs.

Greg Kroah-Hartman:
He pointed out, that we need a solution which integrates dev_xxx()
macros.

Randy Dunlop:
He doesn't want to have message documentation included in the
kernel-doc tool. We should create new tool for kernel messages.

Pavel Machek:
Suggested to use gettext for message documentation / translation.

Useful links:
=============
There already exists a mailing list for the kernel messages topic:
https://lists.linux-foundation.org/mailman/listinfo/lf_kernel_messages

There was an LWN article summarizing some aspects of the discussion:
http://lwn.net/Articles/238948/

Pros and Cons of the different Message ID methods:
==================================================
Message numbers maintained by driver owners:
+ Unique IDs
+ Can be kept stable between different kernel versions
+ Efficient way of matching printk to Documentation or translation
- Difficult to maintain

printk hashes:
+ Easy to maintain
+ Efficient way of matching printk to Documentation or translation
- Additional preprocessor step needed
- No unique IDs
- Ugly in messages, since hashes can have many characters
- Volatile, since typo fixes change hash values

Format strings:
+ No change needed for printks
+ Matching of printk to corresponding documentation or translation is
  not as efficient as using hashes
- No unique IDs

Pros and Cons of external documentation (vs. internal documentation):
====================================================================
+ Developers have less work to do
+ Kernel sources and patches have less lines of code, since message
  descriptions are not contained in the kernel sources.
+ You can support multiple languages

- Hard to keep printks and descriptions up-to-date. If using hashes,
  each typo fix in a printk breaks the link to your documentation.
- Since the developer knows the meaning of a printk best, he probably
  would be the right person to write the description.
- For every Distribution or vanilla kernel you probably need separate
  external message databases.

Pros and Cons of using component names in printks:
==================================================
+ Makes it easier to identify source of message
+ Makes message more unique (especially, when using Hashes or format
  strings as message IDs)
- Changes of printks necessary

Implementation issues (depending on what solution we implement):
===============================================================
* Preprocessor tool for hashes
* Check tool for messages/message description
* Tool to extract kernel documentation from kernel tree
* Sysadmin tool to query message descriptions
* New kernel macros for Messages to support Component names / message
  numbers


