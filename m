Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbXIOWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbXIOWBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 18:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXIOWBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 18:01:10 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:58648 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXIOWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 18:01:07 -0400
Message-ID: <46EC5616.1000101@freedesktop.org>
Date: Sat, 15 Sep 2007 15:00:54 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linux-sparse@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Sparse 0.4 released
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB0504EE5A76DF9E2293E9C08"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB0504EE5A76DF9E2293E9C08
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have tagged and tarballed Sparse 0.4, now available from
<http://kernel.org/pub/software/devel/sparse/dist/sparse-0.4.tar.gz>,
with sha1sum `a77a10174c8cdb5314eb5000c1e4f24458848b91`.

Highlights and visible changes in this release:

* The Sparse validation files have become an automated test suite,
  invoked via `make check`.  Thanks to Damien Lespiau for the initial
  `test-suite` script.  Also thanks to Pavel Roskin for ideas,
  discussion, and prototyping, and to the contributors of new test
  cases and test-suite metadata for existing test cases.
* New backend `c2xml` by Rob Taylor, which outputs an XML
  representation of the variable declarations, function declarations,
  and data structures in a C file.
* `sparse` and `cgcc` now have manpages.
* Warning changes:
  * Warn on `return <void expression>;` if given `-Wreturn-void`; off
    by default because the C99 standard permits this.
  * Sparse now defaults to -Wno-do-while.
  * Sparse now defaults to -Wdecl.
  * -Wno-old-initializer turns off warnings about non-C99 struct
    initializers
  * -Wno-non-pointer-null turns off warnings about using a plain
    integer as a NULL pointer
  * Initializer entries defined twice and bitfields without explicit
    signs have changed from errors to warnings.
* `cgcc` no longer passes `-Wall` to `sparse` if given `-Wall` on the
  command line.  `-Wall` turns on all Sparse warnings, including
  experimental and noisy ones.  Don't include it just because a
  project wants to pass `-Wall` to `cc`.  If you really want `cgcc` to
  run `sparse` with `-Wall`, set `CHECK=3D'sparse -Wall'`
* Support for more builtin functions: `__builtin_labs`,
  `__builtin_offsetof`, `__builtin_strcat`, `__builtin_strncat`, and
  `__builtin_strlen`.
* Support for more attributes: `constructor`, `destructor`,
  `__always_inline__`, `__noinline__`, `used`, `__syscall_linkage__`,
  `format_arg`, `cdecl`, `stdcall`, `fastcall`, `dllimport`, and `dllexpo=
rt`.
* Support for the `__DATE__` and `__TIME__` preprocessor symbols.
* Support for `__alignof` (treated like the existing `__alignof__`).
* typeof(bitwise_type) now produces the same type, not an incompatible
  type; thanks to Al Viro.
* Various profile-driven optimizations and changes to compiler
  optimization flags, making Sparse significantly faster.
* Numerous fixes to C standards compliance, thanks to Al Viro.  In
  particular:
  * Sparse now requires integer constant expressions in various
    places, not arbitrary expressions.
  * Sparse now handles NULL pointer constants more correctly.
  * Sparse now resolves pointer types more correctly in conditional
    expressions
* The `graph` backend now outputs significantly better program graphs,
  and the Sparse source code includes some `gvpr` scripts to modify
  these graphs in various ways, such as only showing the callers or
  callees of particular functions.  Thanks to Dan Sheridan.
* Linux-style `make` output; for a more verbose make with full command
  lines, `make V=3D1`.  Thanks to Damien Lespiau.
* Numerous bugfixes and internal cleanups; thanks to the many Sparse
  contributors.

Full changelog:

    Al Viro (51):
          handle __alignof as equivalent of __alignof__
          saner reporting of overlaps in initializers
          check for whitespace before object-like macro body
          fix alignment for _Bool
          fix interaction of typeof with bitwise types
          better recovery from bad operations on bitwise
          make copying of EXPR_INDEX non-lazy
          tie the fields of struct in simple list
          rewrite of initializer handling
          fix handling of typeof on structs
          missing NULL checks in initializer handling
          take cast_to() out of usual_conversions(), do it in callers
          mechanically split compatible_assignment_types()
          null pointer constants have no special meaning for pointer subt=
raction
          remove long-dead variable in evaluate_ptr_add()
          remove useless argument in evaluate_ptr_sub()
          cleanup of evaluate_assign_op()
          clean up the typechecking in arithmetics
          clean up usual_conversions(), kill evaluate_shift()
          fix index conversions in evaluate_ptr_add()
          fix default argument promotion
          move degenerate() down into compatible_assignment_types()
          in case of compound literal we want to delay examining type
          warn on return <void expression>;
          deal with enum members without excessive PITA
          implement __builtin_offsetof()
          fix handling of integer constant expressions
          fix the comma handling in integer constant expressions
          first pass at null pointer constants
          make size_t better approximate the reality
          fix handling of address_space in casts and assignments
          fix handling of pointers in ?:
          saner show_type()
          clean up evaluate_sign()
          integer_promotions() can't get SYM_NODE or SYM_ENUM
          start cleaning type_difference()
          get compatible_assignment_types() deal with all cases
          fix the sanity check in evaluate_ptr_sub()
          rewrite type_difference()
          deal correctly with qualifiers on arrays
          add __builtin_strlen()
          no such thing as array of functions
          new helper: unfoul()
          handling of typeof in evaluate_member_dereference()
          file and global scopes are the same for purposes of struct rede=
fining
          ...,array should degenerate
          sanitize evaluate_ptr_add(), start checking for pointers to fun=
ctions
          fix evaluate_compare()
          sanitize evaluate_postop()
          saner -Wtypesign
          braino in conditional_expression()
    =20
    Alberto Bertogli (1):
          Implement x86-64 support in cgcc.
    =20
    Alexey Dobriyan (2):
          Fix infinite loop in free_preprocessor_line()
          Fix -E handling
    =20
    Christopher Li (2):
          combinations string clean up
          Pass a bitmask of keywords to handle_attributes
    =20
    Damien Lespiau (6):
          Change sparse homepage in ctags headers.
          __DATE__ & __TIME expansion
          Beautify all & install Makefile targets
          test-suite: a tiny test automation script
          test-suite documentation
          Sample test-suite test cases
    =20
    Dan Sheridan (2):
          Improved graph generation using subgraph clusters for functions=

          Add gvpr-based post-processing for graphs
    =20
    Josh Triplett (118):
          Fix website and repository references in FAQ
          Fix the version number
          Remove old version note.
          gitweb lives at git.kernel.org now.
          Add a "make dist" that requires $(VERSION) to match `git descri=
be`
          Add test case for __asm__ __volatile__(...)
          Make cgcc not pass -Wall to sparse even if passing it to cc
          Teach cgcc about all currently existing sparse warning options
          Teach cgcc about -ventry and -vdead
          Parse asm after a label as a statement, not an attribute
          Add test case for stdcall and cdecl attributes.
          Add -Wno-old-initializer to turn off warnings about non-C99 str=
uct initializers
          Add test case for -Wno-old-initializer
          Revert unintentional inclusion of warning fix in previous commi=
t.
          Use %td when printing a ptrdiff_t to avoid problems on 64-bit p=
latforms
          Remove extra space.
          Add shebang to gvpr scripts, make them executable, and change u=
sage accordingly
          Fix an __attribute__() parsing error
          Expand calling convention test case to cover fastcall
          Add -Wno-non-pointer-null to turn off warning about using a pla=
in integer as a NULL pointer
          Add __builtin_strcat and __builtin_strncat.
          Ignore the GCC constructor and destructor attributes
          Remove inaccurate comment designating some attributes as window=
s-specific.
          Move the ident for defined() into the preprocessor section.
          Reorganize attribute list for readability.
          Add double-underscore variant __always_inline__.
          Add double-underscore variant __noinline__.
          Add no-double-underscore variant "used", ignored like "__used__=
".
          Add double-underscore variant __syscall_linkage__.
          Add no-double-underscore variant format_arg.
          Add explanatory comment about direct use of __IDENT for preproc=
essor idents.
          Sparse always defines __STDC__ 1, so cgcc does not need to do s=
o
          Fix old typo: s/wierd/weird/
          Canonicalize URL in FAQ: add www., add trailing slash
          Change "LD" to "LINK" in Makefile prettyprinting.
          Makefile prettyprinting: make INSTALL and other output line up =
correctly
          Add test case for infinite loop in free_preprocessor_line()
          Turn on -Wdecl by default.
          ctags: Use const as appropriate in cmp_sym()
          validation/old-initializer.c: Make the_s static to avoid extran=
eous warning.
          validation/restricted-typeof.c: Make globals static to avoid ex=
traneous warnings.
          validation/escapes.c: Make globals static to avoid extraneous w=
arnings.
          validation/non-pointer-null.c: Make global static to avoid extr=
aneous warning.
          Merge commit 'viro/integer-constant'
          Move all the preprocessor tests into validation/preprocessor/
          Move test-suite output files to validation/.gitignore
          .gitignore: Stop ignoring all dotfiles
          validation: Update comments for current Sparse behavior and tes=
t-suite.
          Add test-suite comments to all the obvious preprocessor tests
          Make preprocessor-loop a normal numbered preprocessor test
          Add test-suite comment to preprocessor21.
          Add test-suite comment to address_space.c
          Make clean depend on clean-check
          Rename asm-volatile to better describe what it tests
          Add test-suite comment to label-asm.c
          Remove "check-exit-value: 0" and rely on default; remove extra =
blank line.
          Add test-suite comment to bad-array-designated-initializer.c
          Add c2xml to .gitignore
          Split c2xml build rule into compile and link stages, and add th=
e quiet prefixes
          expression.h needs lib.h for struct position and symbol.h for i=
nt_ctype
          Fix GCC warnings in c2xml
          Fix sparse warnings in c2xml: mark globals static and remove un=
used globals
          Fix test-suite to handle stdout and stderr separately, and fix =
up tests
          Add test-suite metadata to bad-cast.c
          Add test-suite metadata to bad-ternary-cond.c, and remove now-r=
edundant comment
          Add test-suite metadata to initializer-entry-defined-twice.c
          Add test-suite metadata to context.c
          Add test-suite metadata to escapes.c
          Add test-suite metadata to calling-convention-attributes.c
          Fix typos in test-suite documentation
          Makefile: stop cleaning files we didn't make and have no busine=
ss cleaning
          Add test-suite metadata to old-initializer.c; also test with -W=
no-initializer
          allocate.h: Stop needlessly returning a void value in __DO_ALLO=
CATOR
          Turn off -Wdo-while by default.
          Add test-suite metadata to label-attr.c
          validation/builtin_safe1.c: Show the unsafe macro argument
          Make "Initializer entry defined twice" a warning, not an error
          Remove explicit restatements of defaults in metadata for member=
_of_typeof test
          Remove explicit restatements of defaults in metadata for outer-=
scope test
          Remove explicit restatements of defaults in metadata for comma =
test
          Add test case for comparing null pointer constant to int.
          Makefile: Use -O2 -finline-functions, not just -O
          cse: Size insn_hash_table more realistically, speeding up CSE s=
ignificantly
          Add some missing dependencies in the Makefile
          Drop -fpic; it hurts performance and we don't build libsparse.s=
o by default
          Add another test case to validation/comma.c
          ctags: Handle some new namespaces and symbol types.
          is_zero_constant: declare saved const
          Add test case for -Wtypesign
          Sort warning options in lib.c and lib.h
          Rename Wcast_to_address_space to Wcast_to_as to match the comma=
nd-line argument
          Add a manpage for sparse
          Install the Sparse manpage
          cgcc: Sparse accepts -Wcast-to-as, not -Wcast-to-address-space
          Rename Wundefined_preprocessor to Wundef to match the command-l=
ine argument
          cgcc: Sparse accepts -Wundef, not -Wundefined-preprocessor
          Use -fno-strict-aliasing, as the ptrlist code seems to violate =
C99 strict aliasing rules
          Add test-suite annotations to restricted-typeof.c
          Add test-suite annotations to double-semicolon.c
          Add test-suite annotations to check_byte_count-ice.c
          Add test-suite annotations to badtype4.c
          Add test-suite annotations to varargs1.c
          Add test-suite annotations to struct-attribute-placement.c
          Add test-suite annotations to non-pointer-null.c
          Add test-suite annotations to struct-ns1.c
          Add test-suite annotations to noderef.c
          Makefile: Use ?=3D to allow overriding OS or AR on the Make com=
mand line
          FAQ: Point to URL on vger for subscription instructions and arc=
hives
          README: recode from ISO-8859-1 to UTF-8
          validation: Rename typeconvert.c to integer-promotions.c to mat=
ch its purpose
          Add test-suite annotations to integer-promotions.c
          Add test-suite annotations to cond_expr.c
          Add test-suite annotations to function-pointer-modifier-inherit=
ance.c
          validation: Update comment in type1.c to reflect current state =
of Sparse
          Add test-suite annotations to init-char-array.c
          Add a manpage for cgcc
          Add SEE ALSO for cgcc in sparse manpage
          Makefile: VERSION=3D0.4
    =20
    Kovarththanan Rajaratnam (1):
          libxml compile fix on Cygwin
    =20
    Michael Stefaniuc (3):
          Ignore the cdecl and stdcall attributes for now.
          Add test for typedef on pointer to function with stdcall attrib=
ute.
          '\?' is a valid escape character defined by ANSI C. Its value i=
s '?'.
    =20
    Mike Frysinger (1):
          Makefile: improve flag handling
    =20
    Pavel Roskin (5):
          Improve error message if using a member of an incomplete struct=
 or union
          Bitfield without explicit sign should be a warning, not an erro=
r
          cgcc: preserve sparse exit code if -no-compile is used
          Avoid use of libc headers in the validation suite
          Fix warnings about undeclared globals, they are irrelevant to t=
he test
    =20
    Ramsay Jones (2):
          Add (more) support for WIN32 attribute names
          Add cygwin support to cgcc
    =20
    Randy Dunlap (1):
          add __builtin_labs()
    =20
    Rob Taylor (4):
          add end position to symbols
          add sparse_keep_tokens api to lib.h
          new get_type_name function
          add c2xml program
    =20
    Yura Pakhuchiy (1):
          Make cgcc filter out all sparse warning related options
    =20
    ricknu-0@student.ltu.se (4):
          tokenize.c: Replace handwritten strncmp with existing function.=

          expression.c: Clean up match_oplist() and add missing va_end()
          parse.c: Adding va_end().
          tokenize.c: Simplify drop_stream_eoln().

-- Josh Triplett


--------------enigB0504EE5A76DF9E2293E9C08
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG7FYXGJuZRtD+evsRAlzeAKCbv3AaGU/ks6Q19rPC9F1uAFVEkACgmmAB
a8bV2RwCTqOzhU3kAgbGM1M=
=qIB7
-----END PGP SIGNATURE-----

--------------enigB0504EE5A76DF9E2293E9C08--
