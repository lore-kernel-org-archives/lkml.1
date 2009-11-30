Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZK3HTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZK3HTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZK3HTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:19:21 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:45164 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZK3HSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:18:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nR75egvNtlcucAP9WL2dr0va/BjSFn/yDZyShIgIvHUyKV2CCiR+4DmLShhdsbp9rO
         Pl3t8vgyIvDXYUxsRsbmRqSiG/YN5AxezaHHkC82YbC+6odVF2n3GRhBqQmrgDVYNofu
         aaPHmF+sicsQHHqhwOKw7P+lx4DzGROhWbMns=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [PATCH 3/4] perf trace/scripting: fix Perl common_* access functions
Date: Mon, 30 Nov 2009 01:18:48 -0600
Message-Id: <1259565529-6407-4-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
References: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common_* functions (e.g. common_pc(), etc) are exported as
common_* but named get_common_*, resulting in unresolved subroutine
errors when executing scripts.  Make the internal and external names
match.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |   30 ++++++++++----------
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    6 ++--
 tools/perf/util/trace-event-perl.c                 |    6 ++--
 tools/perf/util/trace-event-perl.h                 |    6 ++--
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index 3ba3ffc..af78d9a 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -39,8 +39,8 @@
 
 #line 41 "Context.c"
 
-XS(XS_Perf__Trace__Context_get_common_pc); /* prototype to pass -Wmissing-prototypes */
-XS(XS_Perf__Trace__Context_get_common_pc)
+XS(XS_Perf__Trace__Context_common_pc); /* prototype to pass -Wmissing-prototypes */
+XS(XS_Perf__Trace__Context_common_pc)
 {
 #ifdef dVAR
     dVAR; dXSARGS;
@@ -48,22 +48,22 @@ XS(XS_Perf__Trace__Context_get_common_pc)
     dXSARGS;
 #endif
     if (items != 1)
-       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::get_common_pc", "context");
+       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::common_pc", "context");
     PERL_UNUSED_VAR(cv); /* -W */
     {
 	struct scripting_context *	context = INT2PTR(struct scripting_context *,SvIV(ST(0)));
 	int	RETVAL;
 	dXSTARG;
 
-	RETVAL = get_common_pc(context);
+	RETVAL = common_pc(context);
 	XSprePUSH; PUSHi((IV)RETVAL);
     }
     XSRETURN(1);
 }
 
 
-XS(XS_Perf__Trace__Context_get_common_flags); /* prototype to pass -Wmissing-prototypes */
-XS(XS_Perf__Trace__Context_get_common_flags)
+XS(XS_Perf__Trace__Context_common_flags); /* prototype to pass -Wmissing-prototypes */
+XS(XS_Perf__Trace__Context_common_flags)
 {
 #ifdef dVAR
     dVAR; dXSARGS;
@@ -71,22 +71,22 @@ XS(XS_Perf__Trace__Context_get_common_flags)
     dXSARGS;
 #endif
     if (items != 1)
-       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::get_common_flags", "context");
+       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::common_flags", "context");
     PERL_UNUSED_VAR(cv); /* -W */
     {
 	struct scripting_context *	context = INT2PTR(struct scripting_context *,SvIV(ST(0)));
 	int	RETVAL;
 	dXSTARG;
 
-	RETVAL = get_common_flags(context);
+	RETVAL = common_flags(context);
 	XSprePUSH; PUSHi((IV)RETVAL);
     }
     XSRETURN(1);
 }
 
 
-XS(XS_Perf__Trace__Context_get_common_lock_depth); /* prototype to pass -Wmissing-prototypes */
-XS(XS_Perf__Trace__Context_get_common_lock_depth)
+XS(XS_Perf__Trace__Context_common_lock_depth); /* prototype to pass -Wmissing-prototypes */
+XS(XS_Perf__Trace__Context_common_lock_depth)
 {
 #ifdef dVAR
     dVAR; dXSARGS;
@@ -94,14 +94,14 @@ XS(XS_Perf__Trace__Context_get_common_lock_depth)
     dXSARGS;
 #endif
     if (items != 1)
-       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::get_common_lock_depth", "context");
+       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::common_lock_depth", "context");
     PERL_UNUSED_VAR(cv); /* -W */
     {
 	struct scripting_context *	context = INT2PTR(struct scripting_context *,SvIV(ST(0)));
 	int	RETVAL;
 	dXSTARG;
 
-	RETVAL = get_common_lock_depth(context);
+	RETVAL = common_lock_depth(context);
 	XSprePUSH; PUSHi((IV)RETVAL);
     }
     XSRETURN(1);
@@ -124,9 +124,9 @@ XS(boot_Perf__Trace__Context)
     PERL_UNUSED_VAR(items); /* -W */
     XS_VERSION_BOOTCHECK ;
 
-        newXSproto("Perf::Trace::Context::get_common_pc", XS_Perf__Trace__Context_get_common_pc, file, "$");
-        newXSproto("Perf::Trace::Context::get_common_flags", XS_Perf__Trace__Context_get_common_flags, file, "$");
-        newXSproto("Perf::Trace::Context::get_common_lock_depth", XS_Perf__Trace__Context_get_common_lock_depth, file, "$");
+        newXSproto("Perf::Trace::Context::common_pc", XS_Perf__Trace__Context_common_pc, file, "$");
+        newXSproto("Perf::Trace::Context::common_flags", XS_Perf__Trace__Context_common_flags, file, "$");
+        newXSproto("Perf::Trace::Context::common_lock_depth", XS_Perf__Trace__Context_common_lock_depth, file, "$");
     if (PL_unitcheckav)
          call_list(PL_scopestack_ix, PL_unitcheckav);
     XSRETURN_YES;
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index 24facb3..fb78006 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -28,14 +28,14 @@ MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
 
 int
-get_common_pc(context)
+common_pc(context)
 	struct scripting_context * context
 
 int
-get_common_flags(context)
+common_flags(context)
 	struct scripting_context * context
 
 int
-get_common_lock_depth(context)
+common_lock_depth(context)
 	struct scripting_context * context
 
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index d179ade..2e1cc3c 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -242,7 +242,7 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-int get_common_pc(struct scripting_context *context)
+int common_pc(struct scripting_context *context)
 {
 	int pc;
 
@@ -251,7 +251,7 @@ int get_common_pc(struct scripting_context *context)
 	return pc;
 }
 
-int get_common_flags(struct scripting_context *context)
+int common_flags(struct scripting_context *context)
 {
 	int flags;
 
@@ -260,7 +260,7 @@ int get_common_flags(struct scripting_context *context)
 	return flags;
 }
 
-int get_common_lock_depth(struct scripting_context *context)
+int common_lock_depth(struct scripting_context *context)
 {
 	int lock_depth;
 
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
index 666a864..8fe0d86 100644
--- a/tools/perf/util/trace-event-perl.h
+++ b/tools/perf/util/trace-event-perl.h
@@ -44,8 +44,8 @@ struct scripting_context {
 	void *event_data;
 };
 
-int get_common_pc(struct scripting_context *context);
-int get_common_flags(struct scripting_context *context);
-int get_common_lock_depth(struct scripting_context *context);
+int common_pc(struct scripting_context *context);
+int common_flags(struct scripting_context *context);
+int common_lock_depth(struct scripting_context *context);
 
 #endif /* __PERF_TRACE_EVENT_PERL_H */
-- 
1.6.4.GIT

