Return-Path: <linux-kernel-owner+w=401wt.eu-S1423646AbXEAVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423646AbXEAVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423644AbXEAVJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:09:28 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:54404 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423646AbXEAVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:09:26 -0400
Message-ID: <4637AAF4.5060502@freedesktop.org>
Date: Tue, 01 May 2007 14:02:44 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-sparse@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] Sparse 0.3 released
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3FB34DD6FEDCC58D93452ECC"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3FB34DD6FEDCC58D93452ECC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have tagged and tarballed a 0.3 release of Sparse, now available from
<http://kernel.org/pub/software/devel/sparse/dist/sparse-0.3.tar.gz>,
with sha1sum `1d868b29234176abd5f3f5463aad1f11d5268dc2`.

Note that the Sparse Git repository has moved to:

    git://git.kernel.org/pub/scm/devel/sparse/sparse.git

The old repository location will continue to work for now, but please upd=
ate
any references you have to the old location.

Thanks to Christopher Li for contributing heavily to this release, includ=
ing
several notable new features.  See the full changelog for details.

In addition to numerous bug fixes, cleanups, and new test cases, this rel=
ease
includes several new visible features:

* A Sparse-based implementation of ctags, thanks to Christopher Li.  Now =
you
  can have a ctags that **actually parses C**.
* Sparse now correctly supports annotations on inline functions.
* The new `-ventry` option will make Sparse dump its internal linearized
  bytecode format.
* Sparse now parses the `__regparm__` attribute just like `regparm`, fixi=
ng a
  warning with pthreads from glibc 2.5.
* Sparse now interprets the integer size attributes `QI`, `SI`, `HI`, and=
 `DI`,
  and their double-underscore variants.
* Sparse now supports attributes on labels, sometimes used to specify `un=
used`
  labels.
* Sparse now handles structure attributes between the structure keyword a=
nd the
  name, fixing many parse errors.
* Sparse now supports more than one command-line include file.
* The pkg-config file gets installed to its correct location under `lib`,=

  rather than under `share`.

Notable internal changes:

* Fully table-driven attribute parsing.  This simplifies the C parser and=
 makes
  it far easier to add new attributes to Sparse.
* Many internal cleanups, more information preserved for backends, more u=
seful
  formats for that information, and lower memory usage.
* Fixed Sparse warnings about itself.

Full changelog:

    Christopher Li (24):
          Sparse-based Ctags implementation
          Change the symbol access list to a pseudo list
          Add instruction to pseudo user tracking.
          Update usage chain for dead instructions
          Update usage chain for dead branch instruction.
          Allow more than one command line include file.
          Enhance debug information.
          Another attempt to fix the attribute parsing.
          Marking anonymous string.
          Bug fix in pointer modifier inheritance at function degeneratio=
n.
          Handle structure attributes between the structure keyword and t=
he name
          Fix the segfault when initializer has unknown symbol
          Fix double semicolon in struct declaration
          Make the ptrlist using the sparse allocator.
          Fix core dump on anonymous symbol.
          Fix a bug that match_idents forget to end with NULL
          Adding debug option for showing the linearized instruction.
          Fix core dump on huge switch
          Introduce expression_error
          Disable liveness "dead" instruction by default.
          Add annotation for inline function call.
          Introduce keyword driven attribute parsing
          Fix the annotated inline call position
          handle label attributes
   =20
    Christopher Li and Josh Triplett (4):
          Introduce top level parsing for asm parsing.
          Introducing statement keywords
          Free up some special bits in modifiers.
          Moving statement parsing into smaller functions.

    James Westby (2):
          Fix mistaken comparison that becomes a no-op.
          Update the information in README about using the library.
   =20
    Josh Triplett (30):
          Add ctags to .gitignore
          Add a return in the last case of a switch; redundant but less e=
rror-prone.
          Coding style fix: in a pointer type, * goes with the name, not =
the type.
          Add missing #include "allocate.h" in linearize.h for DECLARE_AL=
LOCATOR.
          Add test case for function pointer modifier inheritance
          Add test case for structure attribute placement.
          Add test case for double semicolon in structure declaration.
          Coding style fix: use parentheses with sizeof
          Move pkg-config file to lib, rather than share
          Add static to declarations in test cases, to remove unrelated w=
arnings.
          Fix typo in symbol.h: s/keywrods/keywords/
          Fix typos in comments
          Use GCC format and sentinel attributes on appropriate functions=

          Fix two potential NULL pointer dereferences in dissect.c
          Avoid returning an uninitialized pointer from dup_list of an em=
pty list
          Remove stray space from expand_compare in expand.c
          Prevent potential NULL pointer dereference in expand_compare
          Add test case for basic address_space annotations.
          Use noreturn on die() and error_die()
          Parse and ignore the __regparm__ attribute, just like regparm.
          Fix comment to reference #weak_define rather than #ifndef, matc=
hing code
          Teach cgcc about -Wtransparent-union and -Wno-transparent-union=

          Declare die_if_error extern in lib.h
          Remove unused variable "include" from lib.c
          Declare do_error static
          Declare gcc_patchlevel extern in lib.h
          compile-i386.c: Declare regs_in_use static
          simplify.c: Declare delete_pseudo_user_list_entry static
          linearize: DECLARE_ALLOCATOR for asm_constraint and asm_rules
          Fix most -Wshadow warnings in Sparse.
   =20
    Oleg Nesterov (3):
          dissect: cleanup report_implicit()
          dissect: fix multidimensional array initializer
          dissect: simplify lookup_member()

-- Josh Triplett


--------------enig3FB34DD6FEDCC58D93452ECC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGN6r0GJuZRtD+evsRAgdhAJ9pQwusW5KLPv8QxGgnVosTT03L2ACfeewJ
nBtRVsAtZmf6qc7oENhIJKo=
=gppI
-----END PGP SIGNATURE-----

--------------enig3FB34DD6FEDCC58D93452ECC--
