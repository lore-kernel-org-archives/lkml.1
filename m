Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbZHWESG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbZHWESG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 00:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZHWESE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 00:18:04 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:59890 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZHWESB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 00:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=ZcrL4niZuIZnfaiUd8pDQnR4HVu9vcoD
	I2U1bZlTHXKywN5Nnp4jfnOEq828hw0OWFcQRMO5p8AnLR91FdtDCRJJf8oCmYAO
	rAr8dgcQCkfIS2Uo79keMLaodYQlDXcDZrbUdCxnsEUrSFqpUjWg4CWxbaP63Gxp
	GXabe+yrXfs=
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/6] Lazy workqueues
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
 <1250769861.8282.182.camel@twins> <20090820120858.GJ12579@kernel.dk>
 <1250770571.8282.186.camel@twins>
From: Junio C Hamano <junio@pobox.com>
Date: Sat, 22 Aug 2009 19:42:04 -0700
In-Reply-To: <1250770571.8282.186.camel@twins> (Peter Zijlstra's message of
 "Thu\, 20 Aug 2009 14\:16\:11 +0200")
Message-ID: <7vfxbj1car.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 918BEF4A-8F8E-11DE-BAF5-CA0F1FFB4A78-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, 2009-08-20 at 14:08 +0200, Jens Axboe wrote:
> ...
>> That's pretty new... But perhaps I should complain too, it's been
>> annoying me forever.
>
> http://marc.info/?l=git&m=123457137328461&w=2
>
> Apparently it didn't happen, nor did I ever see a reply to that posting.
>
> Junio, what happened here?

Nothing happened.

I do not recall anybody objecting to, but then when nothing happened in
neither 1.6.3 nor 1.6.4, nobody jumped up-and-down demanding the change of
default either.  So overall impression I got from this was that nobody
really cared deeply enough either way.

But we are talking about 1.7.0 to become a release to correct wrong
defaults we have had once and for all ;-), and I am tempted to roll this
topic into the mix.  Here is what I queued to my 'next' branch tonight.

-- >8 --
From: Junio C Hamano <gitster@pobox.com>
Date: Sat, 22 Aug 2009 12:48:48 -0700
Subject: [PATCH] send-email: make --no-chain-reply-to the default

In http://article.gmane.org/gmane.comp.version-control.git/109790 I
threatened to announce a change to the default threading style used by
send-email to no-chain-reply-to (i.e. the second and subsequent messages
will all be replies to the first one), unless nobody objected, in 1.6.3.

Nobody objected, as far as I can dig the list archive.  But when nothing
happened in 1.6.3 nor 1.6.4, nobody from the camp who complained loudly
that led to the message did not complain either.

So I am guessing that after all nobody cares about this.  But 1.7.0 is a
good time to change this, and as I said in the message, I personally think
it is a good change, so here it is.

Signed-off-by: Junio C Hamano <gitster@pobox.com>
---
 Documentation/git-send-email.txt |    6 +++---
 git-send-email.perl              |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/git-send-email.txt b/Documentation/git-send-email.txt
index 767cf4d..626c2dc 100644
--- a/Documentation/git-send-email.txt
+++ b/Documentation/git-send-email.txt
@@ -84,7 +84,7 @@ See the CONFIGURATION section for 'sendemail.multiedit'.
 --in-reply-to=<identifier>::
 	Specify the contents of the first In-Reply-To header.
 	Subsequent emails will refer to the previous email
-	instead of this if --chain-reply-to is set (the default)
+	instead of this if --chain-reply-to is set.
 	Only necessary if --compose is also set.  If --compose
 	is not set, this will be prompted for.
 
@@ -171,8 +171,8 @@ Automating
 	email sent.  If disabled with "--no-chain-reply-to", all emails after
 	the first will be sent as replies to the first email sent.  When using
 	this, it is recommended that the first file given be an overview of the
-	entire patch series. Default is the value of the 'sendemail.chainreplyto'
-	configuration value; if that is unspecified, default to --chain-reply-to.
+	entire patch series. Disabled by default, but the 'sendemail.chainreplyto'
+	configuration variable can be used to enable it.
 
 --identity=<identity>::
 	A configuration identity. When given, causes values in the
diff --git a/git-send-email.perl b/git-send-email.perl
index 0700d80..c1d0930 100755
--- a/git-send-email.perl
+++ b/git-send-email.perl
@@ -71,7 +71,7 @@ git send-email [options] <file | directory | rev-list options >
     --suppress-cc           <str>  * author, self, sob, cc, cccmd, body, bodycc, all.
     --[no-]signed-off-by-cc        * Send to Signed-off-by: addresses. Default on.
     --[no-]suppress-from           * Send to self. Default off.
-    --[no-]chain-reply-to          * Chain In-Reply-To: fields. Default on.
+    --[no-]chain-reply-to          * Chain In-Reply-To: fields. Default off.
     --[no-]thread                  * Use In-Reply-To: field. Default on.
 
   Administering:
@@ -188,7 +188,7 @@ my (@suppress_cc);
 
 my %config_bool_settings = (
     "thread" => [\$thread, 1],
-    "chainreplyto" => [\$chain_reply_to, 1],
+    "chainreplyto" => [\$chain_reply_to, undef],
     "suppressfrom" => [\$suppress_from, undef],
     "signedoffbycc" => [\$signed_off_by_cc, undef],
     "signedoffcc" => [\$signed_off_by_cc, undef],      # Deprecated
-- 
1.6.4.1.255.g5556a


